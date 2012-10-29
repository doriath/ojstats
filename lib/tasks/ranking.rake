namespace :ranking do
  task :refresh => :environment do
    logger = Logger.new STDOUT
    logger.formatter = nil

    User.all.each do |user|
      user.online_judges.each do |online_judge|
        online_judge.refresh
      end
      logger.info "User #{user.display_name} refreshed"
    end
    logger.close
  end
end

task :map_reduce => :environment do
  map = %Q{
    function() {
      emit({user_id: this.user_id, online_judge: this.online_judge} , {score: this.score});
    }
  }

  reduce = %Q{
    function(key, values) {
      var result = { score: 0, num_problems: 0 };
      values.forEach(function(value) {
        result.score += value.score;
        result.num_problems += 1;
      });
      return result;
    }
  }

  AcceptedProblem.
    map_reduce(map, reduce).
    out(inline: true).
    group_by {|d| d["_id"]["user_id"]}.each do |key, values|
      p key
      p values
    end
end
