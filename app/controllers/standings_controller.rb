class StandingsController < ApplicationController
  before_filter :fetch_user_filters

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
    @filter = CustomFilter.new(params[:start_date], params[:end_date])
    generate_filtered_ranking
  end

  def user_filter
    @user_filter = current_user.ranking_filters.find(params[:id])
    @filter_params = @user_filter.get_params

    @filter = CustomFilter.new(@filter_params[:start_date], @filter_params[:end_date])
    generate_filtered_ranking
  end

  private

  def generate_filtered_ranking
    @start_date = @filter.start_date
    @end_date = @filter.end_date
    generate_ranking
  end

  def generate_ranking
    @ranking = Ranking.new(@start_date, @end_date)
  end

  def date_param
    (params[:date] || Date.today).to_date
  end

  def fetch_user_filters
    @user_filters = current_user ? current_user.ranking_filters.all : []
  end
end
