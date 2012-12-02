class Ranking
  def initialize start_date, end_date
    @start_date = start_date
    @end_date = end_date
  end

  def positions
    @positions ||= compute_positions
  end

  private

  def start_time
    @start_date.to_time_in_current_zone
  end

  def end_time
    (@end_date + 1).to_time_in_current_zone
  end

  # @return [Array<RankingPosition>]
  def compute_positions
    summary = raw_map_reduce.group_by { |d| d[:user_id] }

    User.all.map do |user|
      create_ranking_position user, summary[user.id]
    end.sort!{|a,b| b.score <=> a.score}
  end

  # @param [User] user
  # @param [Array<Hash>] summary
  #
  # @return [RankingPosition]
  def create_ranking_position user, summary
    RankingPosition.new user, create_judge_results(summary)
  end

  # @param [Array<Hash>] summary
  #
  # @return [Array<JudgeResult>]
  def create_judge_results summary
    summary ||= []
    ['spoj', 'plspoj'].map do |name|
      create_judge_result name, summary.select { |s| s[:online_judge] == name }.first
    end
  end


  # @param [String] judge_name
  # @param [Hash] summary
  #
  # @return [JudgeResult]
  def create_judge_result judge_name, summary
    if summary == nil
      JudgeResult.new(judge_name, 0, 0)
    else
      JudgeResult.new(judge_name, summary[:score], summary[:num_problems])
    end
  end

  # @example
  #
  #   [
  #    {user_id: '134yt1r4', online_judge: 'spoj', score: 1.23, num_problems: 2}
  #   ]
  #
  # @return [Array<Hash>]
  def raw_map_reduce
    map = %Q{
      function() {
        emit({user_id: this.user_id, online_judge: this.online_judge},
             {score: this.score, num_problems: 1});
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = { score: 0, num_problems: 0 };
        values.forEach(function(value) {
          result.score += value.score;
          result.num_problems += value.num_problems;
        });
        return result;
      }
    }

    raw_documents = []
    begin
      raw_documents = AcceptedProblem.
        where(accepted_at: start_time..end_time).
        map_reduce(map, reduce).
        out(inline: true).to_a
    rescue
    end

    raw_documents.map do |document|
      {
        user_id: document["_id"]["user_id"],
        online_judge: document["_id"]["online_judge"],
        score: document["value"]["score"],
        num_problems: document["value"]["num_problems"]
      }
    end
  end
end
