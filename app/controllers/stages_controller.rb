class StagesController < ApplicationController
  before_filter :get_group
  before_filter :authorize_creator, only: [:edit, :update, :create, :new, :destroy]

  def show
    @stage = @group.stages.find(params[:id])
    @ranking = GroupRanking.new(@group, @stage)
  end

  def new
    @stage = @group.stages.build
  end

  def edit
    @stage = @group.stages.find(params[:id])
  end

  def create
    @stage = @group.stages.new(params[:stage])
    if @stage.save
      redirect_to @group, notice: 'Stage was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @stage = @group.stages.find(params[:id])

    if @stage.update_attributes(params[:stage])
      redirect_to @group, notice: 'Stage was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @stage = @group.stages.find(params[:id])
    @stage.destroy
    redirect_to @group, notice: "Stage deleted"
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

  def authorize_creator
    unless @group.created_by? current_user
      redirect_to root_url, alert: "You cannot manage this group"
    end
  end
end
