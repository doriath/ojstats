class FiltersController < ApplicationController
  def save
    hash = {start_date: params[:start_date], end_date: params[:end_date]}
    @filter = current_user.ranking_filters.new(params: hash, name: params[:filter_name])
    @filter.save!
    render json: { id: @filter.id }
  end

  def destroy
    @filter = current_user.ranking_filters.find(params[:id])
    @filter.delete
    redirect_to all_time_standings_path
  end
end
