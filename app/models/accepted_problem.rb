class AcceptedProblem
  include Mongoid::Document

  field :online_judge, type: String
  field :accepted_at, type: DateTime
  field :score
  field :reason_why_zero, type: String

  belongs_to :user
  belongs_to :problem

  scope :ordered, desc(:accepted_at)
end
