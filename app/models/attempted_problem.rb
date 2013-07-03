class AttemptedProblem
  include Mongoid::Document

  field :online_judge, type: String
  field :attempted_at, type: DateTime
  field :result

  belongs_to :user
  belongs_to :problem
end
