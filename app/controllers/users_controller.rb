class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def import
    current_user.import_accepted_problems
    Ranking.global.rebuild
    redirect_to edit_user_registration_path
  end
end
