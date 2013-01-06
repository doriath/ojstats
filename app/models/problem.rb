class Problem
  include Mongoid::Document

  field :online_judge, type: String
  field :name, type: String
  field :url, type: String
  field :score, type: Float
  field :num_accepts, type: Integer
  field :max_points, type: Float
  field :banned, type: Boolean, default: false
  field :ban_reason, type: String

  has_many :accepted_problems

  def fetch_max_points
    unless max_points
      fetched_problem = Problem.scraper(online_judge).fetch_problem(name)
      self.max_points = [fetched_problem.best_points, fetched_problem.worst_points].max
      save!
    end
    max_points
  end

  def self.find_or_fetch_by(attributes)
    problem = Problem.where(attributes)
    if (problem.first)
      problem.first
    else
      fetched_problem = scraper(attributes[:online_judge]).fetch_problem(attributes[:name])
      create_from_scraper!(fetched_problem, attributes[:online_judge])
    end
  end

  # @param [OnlineJudges::Problem] data
  # @param [String] online_judge_name
  def self.create_from_scraper!(data, online_judge_name)
    score = 1
    if data.num_accepts and data.num_accepts != -1
      score = case online_judge_name
              when 'spoj'
                360.0 / (120.0 + data.num_accepts)
              when 'plspoj'
                90.0 / (30.0 + data.num_accepts)
              else
                1
              end
      score = [score, 0.1].max
    end

    Problem.create! do |problem|
      problem.name = data.name
      problem.url = data.url
      problem.online_judge = online_judge_name
      problem.score = score
      problem.num_accepts = data.num_accepts
      problem.max_points = [data.best_points, data.worst_points].max
    end
  end

  def self.scraper(name)
    if name == 'plspoj'
      OnlineJudges::PolishSpoj.new
    elsif name == 'spoj'
      OnlineJudges::EnglishSpoj.new
    else
      raise 'Unknown online judge'
    end
  end
end
