class Ranking
  def initialize start_date, end_date
    @start_date = start_date
    @end_date = end_date
  end

  def positions
    @positions ||= compute_positions
  end

  private

  def compute_positions
    User.all.map{ |user| RankingPosition.new(user, @start_date, @end_date) }.sort!{|a,b| b.score <=> a.score}
  end
end
