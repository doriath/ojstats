class Group
  include Mongoid::Document
  field :name, type: String
  field :creator_id, type: String

  has_one :creator, class_name: 'User', inverse_of: :groups
end
