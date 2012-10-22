class StandingsController < ApplicationController
  before_filter :get_date, except: :custom

  def week
    @start_date = @start_date - @start_date.cwday.days
    @end_date = @start_date + 6.days
    generate_ranking
  end

  def month
    @start_date = @start_date - @start_date.day + 1.day
    @end_date = @start_date.next_month - @start_date.next_month.day
    generate_ranking
  end

  def year
    @start_date = @start_date - @start_date.yday + 1.day
    @end_date = @start_date.next_year - @start_date.next_year.yday
    generate_ranking
  end

  def all_time
    @end_date = @start_date
    @start_date = Date.parse("1970-01-01")
    generate_ranking
  end

  def custom
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    generate_ranking
  end

  private

  def generate_ranking
    @ranking = Ranking.new(@start_date, @end_date)
  end

  def get_date
    @start_date = params[:date].to_date || Date.today
  end
end
