class MessagesController < ApplicationController
  def create
    Message.create!(outbound_message_params)
  end

  private

  def outbound_message_params
    params.permit(:to_number,:message,:callback_url)
  end
end
