class AuthenticationController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token
  layout false
  def sign_in
    @user = User.new
  end

  def login
    username_or_email = params[:user][:username]
    password = params[:user][:password]

    if username_or_email.rindex('@')
      email=username_or_email
      user = User.authenticate_by_email(email, password)
    else
      username=username_or_email
      user = User.authenticate_by_username(username, password)
    end

    if user
      session[:user_id] = user.id
      flash[:notice] = 'Welcome.'
      redirect_to welcome_url
    else
      flash.now[:error] = 'Unknown user. Please check your username and password.'
      render :action => "sign_in"
    end
  end

  def signed_out
    session[:user_id] = nil
    render :action => "sign_in"
  end

  def new_user
    @user = User.new
  end

  def register
    @user = User.new(user_params)
    @user.user_type='tailor'
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect_to welcome_path
    else
      render :action => "new_user"
    end
  end

  def account_settings
    @user = current_user
    render :layout => 'application'
  end

  def set_account_info
  old_user = current_user
  @user = User.authenticate_by_username(old_user.username, params[:user][:password])

    if @user.nil?
      @user = current_user
      @user.errors[:password] = "Password is incorrect."
      render :action => "account_settings"
    else
      @user.update(edit_user_params)
      if @user.valid?
        # If there is a new_password value, then we need to update the password.
        @user.password = @user.new_password unless @user.new_password.nil? || @user.new_password.empty?
        @user.save
        flash[:notice] = 'Account settings have been changed.'
        redirect_to welcome_path
      else
        render :action => "account_settings"
      end
    end
  end

  def fb_create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to welcome_url
  end

  def save_shop     
      current_user.shop_name = params[:shop_name] 
      current_user.save(:validate => false)
      respond_to do |format|
        format.js
      end
  end
  
  private

  def edit_shop_name
    allow = [:shop_name]
    params.require(:user).permit(allow)
  end

  def user_params
    allow = [:shop_name, :title, :username,:email, :password ]
    params.require(:user).permit(allow)
  end

  def edit_user_params
    allow = [:username,:email,:password,:shop_name, :title]
    params.require(:user).permit(allow)
  end
  
end
