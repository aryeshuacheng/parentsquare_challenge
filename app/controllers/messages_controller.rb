class MessagesController < ApplicationController
  def send_message
    message = Message.create!(outbound_message_params)
    HitApiJob.perform_later(message)
  end

  def delivery_status_queue
    SetStatusJob.set(wait: 2.seconds).perform_later(delivery_status_params)
  end

  private

  def outbound_message_params
    params.permit(:to_number,:message,:callback_url)
  end

  def delivery_status_params
    params.permit(:status,:message_id)
  end
end
