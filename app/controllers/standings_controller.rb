class StandingsController < ApplicationController
  def index
    @date = params[:date]
    @span = params[:span]
    @ranking = Ranking.new(@date, @span)
  end
end

