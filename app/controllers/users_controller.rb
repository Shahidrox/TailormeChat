class UsersController < ApplicationController
  #before_filter :require_login
  def welcome
  	#@user =User.where(:user_type => nil)
    @user =User.all
  end

  def message_notification
    sender=current_user.id
    @all_msg=Message.where("(sender=?) or (receiver=?)",sender,sender).order("id DESC")
  end

  def people
  	#@user =User.all
    @user =User.where("shop_name=? and id != ?", current_user.shop_name, current_user.id)
  end
  
  def message_shop
    @shop=Shop.where("user_id=?", current_user.id).order("id DESC")
  end

  def create_message_shop
    @client_message = params[:client_message]
    @user_id = params[:user_id]
    @shop_name = params[:shop_name]
    @shop = Shop.new(:user_id => @user_id, :shop_name =>@shop_name, :message => @client_message)
    
    if @shop.save
     # @id =current_user.id 
      puts "===============#{@shop.message}"
      #@shop=Shop.where("user_id=?", @user_id).order("id DESC")
      respond_to do |format|
        format.js { render :layout => false }
      end
    end
  end

  def client_reply
    @all_clients=Shop.where("shop_name=?", current_user.shop_name)
  end

end
