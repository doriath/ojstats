class GroupsController < ApplicationController
  before_filter :authorize_creator, only: [:edit, :update, :create, :new, :destroy]
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])
    @group.creator_id = current_user.id
    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_url
  end

  def authorize_creator
    if (not current_user) or current_user.id.to_s != Group.find(params[:id]).creator_id.to_s
      redirect_to root_url, alert: "You cannot manage this group"
    end
  end
end
