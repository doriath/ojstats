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
end
