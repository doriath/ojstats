class JudgeResult
  attr_reader :name

  def initialize judge_name, user, start_date, end_date
    @name = judge_name
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def points
    @points ||= compute_points
  end

  private

  def compute_points
    @user.accepted_problems.where(accepted_at: @start_date..(@end_date + 1), online_judge: @name).size
  end
end
