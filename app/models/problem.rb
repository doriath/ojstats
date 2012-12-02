class Problem
  include Mongoid::Document

  field :online_judge, type: String
  field :name, type: String
  field :url, type: String
  field :score, type: Float

  has_many :accepted_problems

  def self.find_or_fetch_by(attributes)
    problem = Problem.where(attributes)
    if (problem.first)
      problem.first
    else
      Problem.create!(name: attributes[:name], online_judge: attributes[:online_judge], score: 1)
    end
  end

  # @param [OnlineJudges::Problem] data
  # @param [String] online_judge_name
  def self.create_from_scraper!(data, online_judge_name)
    score = 1
    if data.num_accepts
      score = case online_judge_name
              when 'spoj'
                80.0 / (40.0 + data.num_accepts)
              when 'plspoj'
                20.0 / (10.0 + data.num_accepts)
              else
                1
              end
      score = [score, 0.1].max
    end

    Problem.create!(
      name: data.name,
      online_judge: online_judge_name,
      score: score)
  end
end
