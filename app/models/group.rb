class Group
  include Mongoid::Document
  field :name, type: String
  field :creator_id, type: String

  has_one :creator, class_name: 'User', inverse_of: :created_groups
  has_and_belongs_to_many :users
  has_many :stages

  def current_stage
    self.stages.last
  end

  def created_by? user
    user and user.id.to_s == creator_id.to_s
  end
end
