class StandingsController < ApplicationController
  def index
    @date = params[:date] || Date.today
    @span = params[:span] || 'all_time'
    @ranking = Ranking.new(@date, @span)
  end
end

