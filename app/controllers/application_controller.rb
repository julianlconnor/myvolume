class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif session[:uid]
      @current_user ||= Authorization.find(session[:uid])
    end
  end
end
