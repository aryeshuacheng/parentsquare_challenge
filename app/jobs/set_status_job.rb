class SetStatusJob < ApplicationJob
  queue_as :default

  def perform(delivery_status_params)
    message = Message.where(message_id: delivery_status_params['message_id']).first

    message.update(status: delivery_status_params['status'])
  end
end
