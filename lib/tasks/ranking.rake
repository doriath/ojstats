logger = Logger.new STDOUT
logger.formatter = nil

namespace :ranking do
  task :refresh => :environment do
    User.all.each do |user|
      user.online_judges.each do |online_judge|
        online_judge.refresh
      end
      logger.info "User #{user.display_name} refreshed"
    end
  end

  task :clean => :environment do
    logger.info "Removing all problems and accepts"
    AcceptedProblem.delete_all
    Problem.delete_all
  end

  task :problem_scores => :environment do
    logger.info "Updating all problems scores"
    [OnlineJudges::PolishSpoj.new, OnlineJudges::EnglishSpoj.new].each do |scraper|
      scraper.fetch_all_problems.each do |problem|
        Problem.create_from_scraper!(problem, scraper.name)
      end
    end
  end

  task :refresh_all => [:clean, :problem_scores, :refresh] do
  end
end
