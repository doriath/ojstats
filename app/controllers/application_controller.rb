class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_if_online_judges_configured

  private
  def check_if_online_judges_configured
    if current_user && current_user.online_judges.empty?
      flash[:alert] = "Please configure <a href=\"#{online_judges_url}\">online judges</a> to appear in the ranking.".html_safe
    end
  end
end
