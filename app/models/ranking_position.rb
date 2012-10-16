class RankingPosition
  def initialize user, start_date, end_date
    @user = user
    @start_date = start_date
    @end_date = end_date
    @score = total_score
    @judges = judges_scores
  end

  def user_name
    @user.display_name
  end

  def user_id
    @user.id
  end

  def score
    @score
  end

  def judges
    @judges
  end

  private

  def total_score
    @user.accepted_problems.where(accepted_at: @start_date..@end_date).size
  end

  def judges_scores
    ['spoj', 'plspoj'].map{ |online_judge| JudgeResult.new online_judge, @user, @start_date, @end_date }.sort_by{|judge| judge.name }
  end
end
