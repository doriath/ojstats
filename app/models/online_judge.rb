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
      problem = Problem.find_or_fetch_by(name: fetched_problem[:problem], online_judge: name)
      if user.accepted_problems.where(problem_id: problem.id, online_judge: name).first == nil
        user.accepted_problems.create!(problem: problem,
                                  online_judge: name,
                                  accepted_at: fetched_problem[:accepted_at],
                                  score: problem.score)
      end
    end
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
