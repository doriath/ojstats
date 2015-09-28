class OnlineJudge
  include Mongoid::Document
  embedded_in :user

  field :login
  field :name

  validates_presence_of :login
  validates_presence_of :name
  validates_inclusion_of :name, in: %w(plspoj spoj)

  def refresh
    already_fetched_accepts = user.accepted_problems.select { |accept| accept.online_judge == name }
    already_fetched_accepts.map! { |a| a.problem.name }

    accepts = fetcher.fetch_accepts(login, already_fetched_accepts)
    accepts.each{ |accept| update_problem(accept)}
  end

  private

  def update_problem accept
    problem = Problem.find_or_fetch_by(name: accept.problem, online_judge: name)

    if user_solved_problem? problem
      remove_attempt(problem) if user_attempted_problem? problem
      return
    end

    user.accepted_problems.create! do |accepted_problem|
      accepted_problem.problem = problem
      accepted_problem.online_judge = name
      accepted_problem.accepted_at = accept.accepted_at
      accepted_problem.score = problem.score
      if accept.points && accept.points != problem.fetch_max_points
        accepted_problem.score = 0.0
        accepted_problem.reason_why_zero = "#{accept.points} / #{problem.fetch_max_points} points"
      end
      if problem.banned?
        accepted_problem.reason_why_zero = problem.ban_reason
      end
    end
  end

  def user_solved_problem? problem
    accept = user.accepted_problems.select { |p| p.problem_id == problem.id && p.online_judge == name }.first
    if accept
      user.accepted_problems.destroy_all(problem_id: problem.id, online_judge: name) if accept.score == 0.0
      return accept.score > 0
    else
      return false
    end
  end

  def update_attempt attempt
    problem = Problem.find_or_fetch_by(name: attempt.problem, online_judge: name)

    return if user_solved_problem? problem

    if user_attempted_problem? problem
      old = get_attempt problem
      if old.attempted_at < attempt.attempted_at
        user.attempted_problems.find(old.id).update_attributes!(
          {
            attempted_at: attempt.attempted_at,
            result: attempt.result
          }
        )
      end
    else
      user.attempted_problems.create! do |attempted_problem|
        attempted_problem.problem = problem
        attempted_problem.online_judge = name
        attempted_problem.attempted_at = attempt.attempted_at
        attempted_problem.result = attempt.result
      end
    end
  end

  def remove_attempt problem
    user.attempted_problems.delete(get_attempt(problem))
  end

  def user_attempted_problem? problem
    return true if get_attempt problem
    false
  end

  def get_attempt problem
    user.attempted_problems.select { |p| p.problem_id == problem.id && p.online_judge == name }.first
  end

  def fetcher
    if name == 'plspoj'
      OnlineJudges::PolishSpoj.new
    elsif name == 'spoj'
      OnlineJudges::EnglishSpoj.new
    else
      raise 'Unknown online judge'
    end
  end
end
