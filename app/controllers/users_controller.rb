class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @calendar = Calendar.new @user.accepted_problems
  end
end
