class IosIphoneController < ApplicationController
	skip_before_filter :require_login
# This Methode use in Login with facebook
	def android
	    @email=params[:email]
	    @provider=params[:provider]
	    @uid=params[:uid]
	    @token=params[:token]
	    if !params[:uid].to_s.blank?
	      user = User.find_by(email: params[:email])
	      if user
	        session[:user_id] = user.id
	        respond_to do |format|
	          msg = { :status => "ok", :message => "Success!", :id => "#{current_user.id}", :shop_name => "#{current_user.shop_name}"}
	          format.json  { render :json => msg } # don't do msg.to_json
	        end
	      else
	        @user = User.new(:email => @email, :provider => @provider, :uid => @uid, :token => @token)
	        @user.user_type='client'
	        @user.save!(:validate => false)
	        session[:user_id] = @user.id 
	        respond_to do |format|
	          msg = { :status => "ok", :message => "Success!", :id => "#{current_user.id}"}
	          format.json  { render :json => msg } # don't do msg.to_json
	        end
	      end
	    else
	      respond_to do |format|
	        msg = { :status => "error", :message => "Faield"}
	        format.json  { render :json => msg } # don't do msg.to_json
	      end
	    end
  	end

# This Method use for Save Shop name
    def save_shop_ios
	    @id=params[:id]
	    @shop=params[:shop_name]
	    details=User.find(@id)   
	    details.shop_name = @shop
	    if details.save(:validate => false)
	      respond_to do |format|
	        msg = { :status => "ok", :message => "Success!", :shop_name => "#{@shop}"}
	        format.json  { render :json => msg } # don't do msg.to_json
	      end
	    else
	      respond_to do |format|
	        msg = { :status => "error", :message => "Not Save"}
	        format.json  { render :json => msg }
	      end
	    end
    end
    
# Send Email

	def email_io7
		@sender=params[:my_id]                       # Get iphone side
		@receiver=params[:user_id] 
		sender_em=params[:sender_email]
		@messages=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@receiver,@receiver,@sender)
		#.order("id DESC")
		message = []
		@messages.each do |chat|
			sql="SELECT C.id,C.reply,C.created_at,U.id,U.email, U.user_type FROM users U,chats C WHERE C.user_id_fk=U.id and C.message_id_fk='#{chat.id}'"
			chat_details=Message.find_by_sql(sql)
			type_user=User.find_by_sql(sql)
			message << {:email => chat_details.first.email, :type => type_user.first.user_type, :time => chat.created_at, :message => chat_details.first.reply}
		end
		
		UserEmail.send_email_to_user(message,sender_em).deliver
		respond_to do |format|
			format.json { render :json => "Success" }
		end
	end
# This Method use to Send message through client to shop ios
	def create_message_shop_ios
	    @client_message = params[:message]
	    @user_id = params[:user_id]
	    @shop_name = params[:shop_name]
	    @message = Shop.new(:user_id => @user_id, :shop_name =>@shop_name, :message => @client_message)
	    if @message.save(:validate => false)
	      @shop=Shop.where("user_id=?", @user_id)
	      respond_to do |format|
	        msg = { :status => "ok", :chat => @shop }
	        format.json  { render :json => msg } # don't do msg.to_json
	      end
	    else
	      respond_to do |format|
	        msg = { :status => "error", :message => "Not Save"}
	        format.json  { render :json => msg }
	      end
	    end
	end

# This Method use ios inbox
	def message_notification_ios
	    user_id=params[:id]
	    sender=user_id
	    @all_msg=Message.where("(sender=?) or (receiver=?)",sender,sender).order("id DESC")
		data = []
		@all_msg.each do |messages|
			@reply_all=Chat.where("message_id_fk=?",messages.id).select("reply","user_id_fk","created_at", "id")
		    @user=User.where("id=?",@reply_all.first.user_id_fk).select("email","id", "user_type")
		    
		    data << { :email => @user.first.email, :type => @user.first.user_type, :user_id => @user.first.id, :message => @reply_all.first.reply}
		end
		render :json => data.to_json
	end

# This Methode use For Chats
	def create_message_ios
		@sender=params[:my_id]                       # Get iphone side
		@receiver=params[:user_id]                   # Get iphone side
		if ( @sender != @receiver )
			@message = Message.new(:sender => @sender, :receiver =>@receiver)
			@message.save
			@message_getails=Message.all
			@message_id=@message_getails.last.id
			@conversation=params[:message]            # Get iphone side
			@chat=Chat.new(:reply => @conversation, :user_id_fk => @sender, :message_id_fk => @message_id)
			@chat.save
            
			@messages=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@receiver,@receiver,@sender).order("id DESC")
			message = []
			@messages.each do |chat|
				sql="SELECT C.id,C.reply,C.created_at,U.id,U.email, U.user_type FROM users U,chats C WHERE C.user_id_fk=U.id and C.message_id_fk='#{chat.id}'"
    			chat_details=Message.find_by_sql(sql)
    			type_user=User.find_by_sql(sql)

    			message << { :email => chat_details.first.email, :type => type_user.first.user_type, :time => chat.created_at, :message => chat_details.first.reply}
			end
			render :json => message.to_json
		else			
			respond_to do |format|
	        	msg = { :status => "ok", :message => "You Can't post message to your own"}
	        	format.json  { render :json => msg }
	      	end
		end
	end
	def load_messages
		@sender=params[:my_id]                       # Get iphone side
		@receiver=params[:user_id] 
		@messages=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@receiver,@receiver,@sender)#.order("id DESC")
    	
    	message = []
    	@messages.each do |chat|
			sql="SELECT C.id,C.reply,C.created_at,U.id,U.email, U.user_type FROM users U,chats C WHERE C.user_id_fk=U.id and C.message_id_fk='#{chat.id}'"
			chat_details=Message.find_by_sql(sql)
			type_user=User.find_by_sql(sql)
			message << { :email => chat_details.first.email, :type => type_user.first.user_type, :time => chat.created_at, :message => chat_details.first.reply}
		end
		render :json => message.to_json	
	end
# This Methode use For Chats
	def load_tailors
		@shop_name=params[:shop_name]
		@title=params[:title]
		user = User.where(:user_type => "tailor", :shop_name => @shop_name, :title => @title).select("id","username","email")
		if user.nil?
			render json: {message: "No any tailor in this group"}
		else			
		  	details = []
			user.each do |chat|
				details << { :id => chat.id, :type => chat.username, :email => chat.email}
			end
			render :json => details.to_json	
		end
	end
end
