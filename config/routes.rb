Rails.application.routes.draw do
  scope :api do
    resource :messages
  end
end
