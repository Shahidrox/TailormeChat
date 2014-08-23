class UserEmail < ActionMailer::Base
  default from: "from@example.com"
  
  def send_email_to_user(message,sender_em)
    @message = message
    @sender_em = sender_em
     mail(to: "#{@sender_em}")
    # mail(to: "rox.shahid@gmail.com")
  end

  def send_email_to_receiver(your_email,first_chat)
  	@email = your_email
  	@message_first=first_chat
  	# mail(to: "#{@email}")
  	mail(to: "rox.shahid@gmail.com")
  end
  
end
