class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  has_many :accepted_problems
  field :online_judges, type: Hash
  field :display_name, type: String

  def import_accepted_problems
    plspoj_login = online_judges[:plspoj]
    fetched_problems = OnlineJudge::Plspoj.new.fetch_accepted_problems(plspoj_login)

    fetched_problems.each do |fetched_problem|
      problem = Problem.find_or_fetch_by(name: fetched_problem[:problem], online_judge: 'plspoj')
      if accepted_problems.where(problem_id: problem.id, online_judge: 'plspoj').first == nil
        accepted_problems.create!(problem: problem,
                                  online_judge: 'plspoj',
                                  accepted_at: fetched_problem[:accepted_at],
                                  score: problem.score)
      end
    end
  end
end
