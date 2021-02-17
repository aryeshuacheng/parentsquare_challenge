Rails.application.routes.draw do
  scope :api do
    resource :messages do
      post 'delivery_status_queue', to: 'messages#delivery_status_queue'
    end

  end
end
