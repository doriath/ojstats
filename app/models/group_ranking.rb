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
    if @stage
      return @stage.tasks.order_by(:name.asc)
    else
      tasks = []
      @group.stages.each do |stage|
        tasks = tasks.concat(stage.tasks)
      end
      tasks = tasks.sort_by{ |t| [t.name[0], t.name.length, t.name] }
      return tasks
    end
  end

  def states_for user
    tasks.map{ |t| user.solved_problem?(t.problem) ? :accepted : :failed}
  end

  def score_for user
    states_for(user).count(:accepted)
  end
end
