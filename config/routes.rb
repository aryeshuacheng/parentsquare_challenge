Rails.application.routes.draw do
  scope :api do
    scope :messages do
      post 'delivery_status_queue', to: 'messages#delivery_status_queue'
      post 'send_message', to: 'messages#send_message'
    end
  end
end
