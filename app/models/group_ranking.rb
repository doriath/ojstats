class GroupRanking
  def initialize group, stage = nil
    @users = group.users.to_a
    @stage = stage
  end

  def tasks
    @tasks ||= build_tasks
  end

  def users
    @users
  end

  def build_tasks
    if @stage
      @stage.tasks
    end
  end

  def states_for user
    tasks.map{ |t| user.solved_problem?(t.problem) ? :accepted : :failed}
  end
end
