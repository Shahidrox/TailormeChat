class MessagesController < ApplicationController
  def create_message
    #@sender=current_user.id
    @sender=params[:my_id]
    @receiver=params[:user_id]
    if ( @sender != @receiver )
      @message = Message.new(:sender => @sender, :receiver =>@receiver)
      @message.save
      @message_getails=Message.all
      @message_id=@message_getails.last.id
      @conversation=params[:message]
      @chat=Chat.new(:reply => @conversation, :user_id_fk => @sender, :message_id_fk => @message_id)
      @chat.save
      
    end      
  end
  
end
