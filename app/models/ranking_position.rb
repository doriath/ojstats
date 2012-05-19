class RankingPosition
  include Mongoid::Document
  embedded_in :ranking

  field :user, type: String
  field :score, type: Float
end
