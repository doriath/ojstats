class JudgeResult
  attr_reader :name

  def initialize judge_name, user, start_date, end_date
    @name = judge_name
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  # @return [Float] the sum of scores of all problems solved
  def score
    @score ||= compute_score
  end

  # @return [Integer] the number of solved problems
  def num_problems
    @points ||= compute_num_problems
  end

  private

  def compute_num_problems
    @user.accepted_problems.where(accepted_at: @start_date..(@end_date + 1), online_judge: @name).size
  end

  def compute_score
    @user.accepted_problems.where(accepted_at: @start_date..(@end_date + 1), online_judge: @name).sum(:score) || 0
  end
end
