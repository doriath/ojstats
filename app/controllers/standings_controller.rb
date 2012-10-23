class StandingsController < ApplicationController
  def week
    @start_date = date_param.beginning_of_week
    @end_date = date_param.end_of_week
    generate_ranking
  end

  def month
    @start_date = date_param.beginning_of_month
    @end_date = date_param.end_of_month
    generate_ranking
  end

  def year
    @start_date = date_param.beginning_of_year
    @end_date = date_param.end_of_year
    generate_ranking
  end

  def all_time
    @end_date = date_param
    @start_date = Date.new 1970, 1, 1
    generate_ranking
  end

  def custom
    @start_date = start_date_param
    @end_date = end_date_param
    generate_ranking
  end

  private

  def generate_ranking
    @ranking = Ranking.new(@start_date, @end_date)
  end

  def date_param
    (params[:date] || Date.today).to_date
  end

  def start_date_param
    (params[:start_date] || Date.today).to_date
  end

  def end_date_param
    (params[:end_date] || Date.today).to_date
  end
end
