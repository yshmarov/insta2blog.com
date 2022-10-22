class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= InstaUser.find(session[:insta_user_id]) if session[:insta_user_id]
  rescue ActiveRecord::RecordNotFound
    nil
  end
  helper_method :current_user
end
