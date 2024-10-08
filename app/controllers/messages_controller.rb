# frozen_string_literal: true

# Messages controller
class MessagesController < ApplicationController

  def create
    @current_user = current_user
    @message = @current_user.messages.new(content: msg_params[:content], channel_id: params[:channel_id])
    @message.files = msg_params[:attachments]
    @current_user.broadcasts.create(broadcast_type: :new_msg, channel_id: params[:channel_id], broadcast_msg: 'New message')
    return unless @message.save

    render body: nil
  end

  private

  def msg_params
    params.require(:message).permit(:content, attachments: [])
  end
end
