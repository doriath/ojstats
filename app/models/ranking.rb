class Ranking
  def initialize start_date, end_date
    @start_date = start_date.to_datetime
    @end_date = end_date.to_datetime.end_of_day
    @positions = build_standings
  end

  def positions
    @positions
  end

  private

  def build_standings
    User.all.map{ |user| RankingPosition.new(user, @start_date, @end_date) }.sort!{|a, b| b.score <=> a.score}
  end
end
