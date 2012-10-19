class CustomRanking < Ranking
  def initialize start_date, end_date
    @start_date = start_date
    @end_date = end_date
    @positions = build_standings
  end
end
