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

  # TODO move problem banning to separate class
  def ban_problem problem, reason
    problem.update_attributes!(score: 0, banned: true, ban_reason: reason)
  end

  task :ban_problems => :environment do
    logger.info "Banning problems"

    # Ban tutorial problems from english spoj
    url = 'http://www.spoj.com/problems/tutorial/'
    OnlineJudges::Spoj::ProblemsPage.problems_starting_from(url).each do |problem_data|
      ban_problem Problem.create_from_scraper!(problem_data, 'spoj'), "Tutorial problem"
    end

    # Ban challenge problems from english spoj
    url = 'http://www.spoj.com/problems/challenge/'
    OnlineJudges::Spoj::ProblemsPage.problems_starting_from(url).each do |problem_data|
      ban_problem Problem.create_from_scraper!(problem_data, 'spoj'), "Challenge problem"
    end

    # Ban challenge problems from polish spoj
    url = 'http://pl.spoj.com/problems/challenge/'
    OnlineJudges::Spoj::ProblemsPage.problems_starting_from(url).each do |problem_data|
      ban_problem Problem.create_from_scraper!(problem_data, 'plspoj'), "Challenge problem"
    end
  end

  task :refresh_all => [:clean, :problem_scores, :refresh] do
  end
end
