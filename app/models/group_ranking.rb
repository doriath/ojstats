class GroupRanking
  def initialize group, stage = nil
    @users = group.users.to_a
    @stage = stage
    @group = group
  end

  def tasks
    @tasks ||= build_tasks
  end

  def users
    @users
  end

  def build_tasks
    tasks = []
    if @stage
      tasks = @stage.tasks
    else
      @group.stages.each{ |s| tasks = tasks.concat(s.tasks) }
    end
    tasks.sort_by{ |t| [t.name[0], t.name.length, t.name] }
  end

  def states_for user
    tasks.map do |t|
      if user.solved_problem?(t.problem)
        :accepted
      elsif user.attempted_problem(t.problem)
        user.attempted_problem(t.problem).result
      else
        :unattempted
      end
    end
  end

  def score_for user
    states_for(user).count(:accepted)
  end
end
