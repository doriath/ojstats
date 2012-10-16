class JudgeResult
  def initialize judge_name, user, start_date, end_date
    @name = judge_name
    @points = judge_points user, start_date, end_date
  end

  def name
    @name
  end

  def points
    @points
  end

  private

  def judge_points user, start_date, end_date
      user.accepted_problems.where(accepted_at: start_date..end_date, online_judge: name).size
  end
end

