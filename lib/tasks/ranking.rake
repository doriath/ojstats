namespace :ranking do
  task :refresh => :environment do
    logger = Logger.new STDOUT

    User.all.each do |user|
      user.online_judges.each do |online_judge|
        online_judge.refresh
      end
      logger.info "User #{user.display_name} refreshed"
    end
  end
end
