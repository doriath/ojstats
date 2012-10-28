class OnlineJudge
  include Mongoid::Document
  embedded_in :user

  field :login
  field :name

  validates_presence_of :login
  validates_presence_of :name
  validates_inclusion_of :name, in: %w(plspoj spoj)

  def refresh
    fetched_problems = fetcher.fetch_accepted_problems(login)

    fetched_problems.each do |fetched_problem|
      update_problem fetched_problem
    end
  end

  private

  def update_problem fetched_problem
    problem = Problem.find_or_fetch_by(name: fetched_problem[:problem], online_judge: name)
    unless user_solved_problem? problem
      user.accepted_problems.create!(problem: problem, online_judge: name, accepted_at: fetched_problem[:accepted_at], score: problem.score)
    end
  end

  def user_solved_problem? problem
    not user.accepted_problems.select { |p| p.problem_id == problem.id && p.online_judge == name }.empty?
  end

  def fetcher
    if name == 'plspoj'
      OnlineJudges::Plspoj.new
    elsif name == 'spoj'
      OnlineJudges::Spoj.new
    else
      raise 'Unknown online judge'
    end
  end
end
