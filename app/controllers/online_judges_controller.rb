class OnlineJudgesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @online_judges_by_name = current_user.online_judges.group_by { |x| x.name }
  end

  def new
    @online_judge = current_user.online_judges.build(name: params[:name])
  end

  def create
    @online_judge = current_user.online_judges.new(params[:online_judge])
    if @online_judge.save
      redirect_to online_judges_path, notice: 'Online judge has been configured'
    else
      render :new
    end
  end

  def edit
    @online_judge = current_user.online_judges.select { |x| x.name == params[:id] }.first
  end

  def update
    @online_judge = current_user.online_judges.select { |x| x.name == params[:id] }.first
    if @online_judge.update_attributes params[:online_judge]
      current_user.accepted_problems.destroy_all(online_judge: params[:online_judge][:name])
      redirect_to online_judges_path, notice: 'Online judge has been updated'
    else
      render :edit
    end
  end

  def refresh
    @online_judge = current_user.online_judges.select { |x| x.name == params[:id] }.first
    @online_judge.refresh
    redirect_to online_judges_path, notice: 'Online Judge has been refreshed.'
  end
end
