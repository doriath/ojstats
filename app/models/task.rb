# Task is a problem that is added to a group stage to make it visible on group ranks

class Task
  include Mongoid::Document
  field :name, type: String

  belongs_to :stage
  belongs_to :problem
end
