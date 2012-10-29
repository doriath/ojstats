class RankingPosition
  # @params [User] user
  # @params [Array<JudgeResult>] judge_results
  def initialize user, judge_results
    @user = user
    @judge_results = judge_results
  end

  # @return [String]
  def user_name
    @user.display_name
  end

  def user_id
    @user.id
  end

  # @return [Float]
  def score
    @score ||= compute_score
  end

  # @return [Integer]
  def num_problems
    @num_problems ||= compute_num_problems
  end

  # @return [Array<JudgeResult>]
  def judge_results
    @judge_results
  end

  private

  def compute_score
    judge_results.map { |j| j.score }.sum
  end

  def compute_num_problems
    judge_results.map { |j| j.num_problems }.sum
  end
end
