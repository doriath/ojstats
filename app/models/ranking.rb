class Ranking
  include Mongoid::Document

  embeds_many :positions, class_name: 'RankingPosition', inverse_of: :ranking

  def self.global
    Ranking.find_or_create_by
  end

  def rebuild
    self.positions = []
    User.all.each do |user|
      self.positions.create!(user: user, user_name: user.display_name, score: user.accepted_problems.size)
    end
  end
end
