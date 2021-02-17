require 'net/http'

class MessagesController < ApplicationController
  after_action :hit_api, only: [:create]

  def hit_api
    # Send JSON to the API
    # Let's simulate load balancing!
    random = rand(99)

    if random <= 29
      uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1')
    else
      uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
    end

    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {message: @message.message, to_number: @message, callback_url: @message.callback_url}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    # In case something unexpected occurs on the response back
    begin
      message_id = JSON.parse(res.body)['message_id']
    rescue
      message_id = "Failure"
    else
      @message.update(message_id: message_id)
    end
  end

  def create
    @message=Message.create!(outbound_message_params)
  end

  def delivery_status_queue
    SetStatusJob.perform_later(delivery_status_params)
  end

  private

  def outbound_message_params
    params.permit(:to_number,:message,:callback_url)
  end

  def delivery_status_params
    params.permit(:status,:message_id)
  end
end
