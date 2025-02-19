class MessagesController < ApplicationController
  def index
    if params[:type]
      @messages = Message.where(type: params[:type]).order(created_at: :desc)
    else
      @messages = Message.all.order(created_at: :desc)
    end

    respond_to do |format|
      format.html
      format.json { render json: { messages: @messages } }
    end
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to messages_path, notice: "Message was successfully created."
    else
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  private

  def message_params
    params.require(:message).permit(:content, :type, :author)
  end
end
