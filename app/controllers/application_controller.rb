class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_id
  before_filter :check_if_online_judges_configured

  def current_user_id
    @current_user_id ||= current_user.id if current_user
  end

  def authorize_user
    redirect_to root_url, alert: "Sign in first" unless current_user
  end

  private
  def check_if_online_judges_configured
    if current_user && current_user.online_judges.empty?
      flash[:alert] = "Please configure <a href=\"#{online_judges_url}\">online judges</a> to appear in the ranking.".html_safe
    end
  end
end
