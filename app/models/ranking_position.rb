class RankingPosition
  def initialize user, start_date, end_date
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def user_name
    @user.display_name
  end

  def user_id
    @user.id
  end

  def score
    @score ||= compute_score
  end

  def judges
    @judges ||= compute_judges
  end

  private

  def compute_score
    @user.accepted_problems.where(accepted_at: @start_date..@end_date).size
  end

  def compute_judges
    ['spoj', 'plspoj'].map{ |online_judge| JudgeResult.new online_judge, @user, @start_date, @end_date }.sort_by{|judge| judge.name }
  end
end
