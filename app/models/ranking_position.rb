class RankingPosition
  include Mongoid::Document
  embedded_in :ranking

  belongs_to :user
  field :user_name, type: String
  field :score, type: Float
end
