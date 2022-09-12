class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find params[:id]
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new message_params

    if @message.save
      redirect_to messages_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @message = Message.find params[:id]
  end

  def update
    @message = Message.find params[:id]
    @message.assign_attributes message_params

    if @message.save
      redirect_to messages_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @message = Message.find params[:id]

    @message.destroy!

    redirect_to messages_url
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
