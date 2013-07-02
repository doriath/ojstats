class Stage
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  field :name, type: String
  field :begin_time, type: DateTime
  field :end_time, type: DateTime

  belongs_to :group
  has_many :tasks
end
