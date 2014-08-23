class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def welcome
     @all_visis_count=Visit.all.count()
     @client_count=User.where("user_type=? AND shop_name=?","client",current_user.shop_name).count()
     @unread_message_count=Message.where("receiver=? AND is_seen=?",current_user.id,"0").count()
     @notification=Message.where("receiver=? AND is_seen=?",current_user.id,"0").select("sender","MAX(messages.id) as id", "MAX(created_at) as created_at").group("sender").order("created_at DESC")
  end
  
  def chek_notification
    @c_user=params[:my_id]
    @notification=Message.where("receiver=? AND is_seen=?",@c_user,"0").select("sender","MAX(messages.id) as id", "MAX(created_at) as created_at").group("sender").order("created_at DESC")
    respond_to do |format|
      format.js #on { render :json => "Success" }
    end
  end

  def save_title
    current_user.title = params[:title] 
    current_user.save(:validate => false)
    respond_to do |format|
      format.js
    end
  end
  
  def email
    @sender=params[:my_id]                       # Get iphone side
    @receiver=params[:user_id] 
    sender_em=params[:sender_email]
    @messages=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@receiver,@receiver,@sender)
      message = []
      @messages.each do |chat|
        sql="SELECT C.id,C.reply,C.created_at,U.id,U.email, U.user_type FROM users U,chats C WHERE C.user_id_fk=U.id and C.message_id_fk='#{chat.id}'"
        chat_details=Message.find_by_sql(sql)
        type_user=User.find_by_sql(sql)
        message << {:email => chat_details.first.email, :type => type_user.first.user_type, :time => chat.created_at, :message => chat_details.first.reply}
      end
    UserEmail.send_email_to_user(message,sender_em).deliver
    respond_to do |format|
      format.js #on { render :json => "Success" }
    end
  end
  
  def visits
    @all_visits=Visit.all.order("started_at DESC").limit(10)
    @all_visis_count=Visit.all.count()
  end

  def message_notification
    sender=current_user.id
    @all_msg=Message.where("(sender=?) or (receiver=?)",sender,sender).select("receiver","MAX(messages.id) as id", "MAX(sender) as sender", "MAX(created_at) as created_at").group("receiver").order("created_at DESC")
  end

  def people
    @user =User.where("shop_name=? and id != ? and user_type=?", current_user.shop_name, current_user.id, 'client')
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
      puts "===============#{@shop.message}"
      respond_to do |format|
        format.js { render :layout => false }
      end
    end
  end

  def client_reply
    @all_clients=Shop.where("shop_name=?", current_user.shop_name)
  end
  
  
  def create_message
    @sender=params[:my_id]
    @receiver=params[:user_id]
    if ( @sender != @receiver )
      @message = Message.new(:sender => @sender, :receiver =>@receiver)
      @message.save
      @message_getails=Message.all
      @message_id=@message_getails.last.id
      @conversation=params[:message]
      @chatt=Chat.new(:reply => @conversation, :user_id_fk => @sender, :message_id_fk => @message_id)
      @chatt.save
      @read=Message.where("sender=? AND receiver=?",@receiver,@sender)
      @read.update_all(:is_seen => 1)
      @a_email=Message.where("sender=? AND receiver=? AND created_at::date=?",@sender,@receiver,Date.today).select("id").count()
      @chat=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@receiver,@receiver,@sender)#.order("id DESC")
      if @a_email == 1
        resever_email=User.where("id=?",@receiver).select("email")
        cha_message=Chat.where("message_id_fk=?",@chat.first.id).select("reply")
        first_chat=cha_message.last.reply
        your_email=resever_email.first.email
        UserEmail.send_email_to_receiver(your_email,first_chat).deliver
      end      
      respond_to do |format|
        format.js
      end
    end      
  end

  def auto_load_chat
    @sender=params[:my_id]
    @receiver=params[:user_id]
    @chat=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@receiver,@receiver,@sender)#.limit(5).order("created_at DESC")
    respond_to do |format|
      format.js
    end
  end

  def is_seen_method
    @sender=params[:my_id]
    @receiver=params[:user_id]
    @read=Message.where("sender=? AND receiver=?",@receiver,@sender)
    @read.update_all(:is_seen => 1)
    respond_to do |format|
      format.json { render :json => "Success" }
    end
  end
  
end
