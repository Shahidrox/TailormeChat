class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :require_login
  protect_from_forgery
  helper_method :current_user
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
  private
  
    def require_login
      unless current_user
        redirect_to sign_in_path
      end
    end
end
