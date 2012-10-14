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
  embeds_many :online_judges, class_name: 'OnlineJudge', inverse_of: :user

  validates_presence_of :display_name, :email, :encrypted_password

  def points start_date, end_date
    accepted_problems.where(accepted_at: start_date..end_date).size
  end

  def judges_points start_date, end_date
    ['spoj', 'plspoj'].map do |online_judge|
      points = accepted_problems.where(accepted_at: start_date..end_date, online_judge: online_judge).size
      {name: online_judge, points: points}
    end.sort_by{|judge| judge[:name] }
  end
end
