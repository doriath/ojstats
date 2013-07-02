class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Devise fields
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :display_name, type: String
  has_many :accepted_problems
  has_many :ranking_filters
  has_many :created_groups, class_name: 'Group', inverse_of: :creator
  embeds_many :online_judges, class_name: 'OnlineJudge', inverse_of: :user
  has_and_belongs_to_many :groups

  validates_presence_of :display_name, :email, :encrypted_password

  # TODO OPTIMIZE SOOOOOOO UNEFFICENT
  def solved_problem? problem
    self.accepted_problems.where(problem: problem).to_a.any?
  end
end
