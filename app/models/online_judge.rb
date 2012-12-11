class OnlineJudge
  include Mongoid::Document
  embedded_in :user

  field :login
  field :name

  validates_presence_of :login
  validates_presence_of :name
  validates_inclusion_of :name, in: %w(plspoj spoj)

  def refresh
    accepts = fetcher.fetch_accepts(login)

    accepts.each do |accept|
      update_problem accept
    end
  end

  private

  def update_problem accept
    problem = Problem.find_or_fetch_by(name: accept.problem, online_judge: name)

    return if user_solved_problem? problem

    user.accepted_problems.create! do |accepted_problem|
      accepted_problem.problem = problem
      accepted_problem.online_judge = name
      accepted_problem.accepted_at = accept.accepted_at
      accepted_problem.score = problem.score
      if accept.points && accept.points != problem.fetch_max_points
        p accept
        p problem
        accepted_problem.score = 0.0
      end
    end
  end

  def user_solved_problem? problem
    not user.accepted_problems.select { |p| p.problem_id == problem.id && p.online_judge == name }.empty?
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
