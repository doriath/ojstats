class Ranking

  def initialize date, span
    set_dates(date, span)
    @positions = build_standings
  end

  def positions
    @positions
  end

  def set_dates date, span
    @start_date = date.to_date
    if span == 'year'
      get_year_dates
    elsif span == 'month'
      get_month_dates
    elsif span == 'week'
      get_week_dates
    elsif span == 'all_time'
      get_all_dates
    else
      @end_date = @start_date - 1.day
    end
  end

  def get_year_dates
    @start_date = @start_date - @start_date.yday + 1.day
    @end_date = @start_date.next_year - @start_date.next_year.yday
  end

  def get_month_dates
    @start_date = @start_date - @start_date.day + 1.day
    @end_date = @start_date.next_month - @start_date.next_month.day
  end

  def get_week_dates
    @start_date = @start_date - @start_date.cwday.days
    @end_date = @start_date + 6.days
  end

  def get_all_dates
    @end_date = @start_date
    @start_date = Date.parse("1970-01-01")
  end

  def build_standings
    positions = []
    User.all.each do |user|
      positions << { user: user, user_name: user.display_name, score: user.points(@start_date, @end_date), judges_points: user.judges_points(@start_date, @end_date)}
    end
    positions.sort! { |x, y| y[:score] <=> x[:score] }
    positions
  end
end
