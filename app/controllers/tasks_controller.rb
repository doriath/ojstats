class TasksController < ApplicationController
  before_filter :get_group_and_stage
  before_filter :authorize_creator, only: [:edit, :update, :create, :new, :destroy, :index]

  def index
    @tasks = @stage.tasks
  end

  def show
    @task = @stage.tasks.find(params[:id])
  end

  def new
    @task = @stage.tasks.build
  end

  def edit
    @task = @stage.tasks.find(params[:id])
  end

  def create
    @task = @stage.tasks.new(params[:task])
    if @task.save
      redirect_to group_stage_tasks_url(@group, @stage), notice: 'Task was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @task = @stage.tasks.find(params[:id])

    if @task.update_attributes(params[:task])
      redirect_to group_stage_tasks_url(@group, @stage), notice: 'Task was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @task = @stage.tasks.find(params[:id])
    @task.destroy
    redirect_to group_stage_tasks_url(@group, @stage), notice: "Task deleted"
  end

  private

  def get_group_and_stage
    @group = Group.find(params[:group_id])
    @stage = Stage.find(params[:stage_id])
  end

  def authorize_creator
    unless @group.created_by? current_user
      redirect_to root_url, alert: "You cannot manage this group"
    end
  end
end

