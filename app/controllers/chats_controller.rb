class ChatsController < ApplicationController
  def index
    @id=params[:id]
    @user=User.find(params[:id])
    @sender=current_user.id
    @chat=Message.where("(sender=? AND receiver=?) or (sender=? AND receiver=?)",@sender,@id,@id,@sender) #.order("id DESC")
    
    respond_to do |format|
      format.html # new.html.erb
      format.js { render 'message', :format => :html, :layout => false }
      format.json { render json: @chat }
    end
  end

  def show
      sender=current_user.id
      @all_msg=Message.where("(sender=?) or (receiver=?)",sender,sender).order("id DESC")
  end

end
