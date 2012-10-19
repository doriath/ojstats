class StandingsController < ApplicationController
  def index
    @span = params[:span] || 'all_time'
    if @span == 'custom'
      set_custom_ranking
    else
      set_regular_ranking
    end
  end

  private

  def set_custom_ranking
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @ranking = CustomRanking.new(@start_date, @end_date)
  end

  def set_regular_ranking
    @date = params[:date] || Date.today
    @ranking = Ranking.new(@date, @span)
  end
end
