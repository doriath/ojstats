# Task is a problem that is added to a group stage to make it visible on group ranks

class Task
  include Mongoid::Document
  field :name, type: String
  field :url

  belongs_to :stage
end
