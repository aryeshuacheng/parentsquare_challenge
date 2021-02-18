require 'net/http'

class HitApiJob < ApplicationJob
  queue_as :default

  def perform(message)
    provider = Message.choose_provider

    req = Net::HTTP::Post.new(provider[:uri], 'Content-Type' => 'application/json')
    req.body = {message: message.message, to_number: message, callback_url: message.callback_url}.to_json
    res = Net::HTTP.start(provider[:uri].hostname, provider[:uri].port, :use_ssl => provider[:uri].scheme == 'https') do |http|
      http.request(req)
    end
    
    begin
      message_id = JSON.parse(res.body)['message_id']
    rescue
    else
      if res.code.to_s.to_i == 200
        message.update(internal_status:"Initial API call returned 200.", message_id: message_id)
        # Possibly write in a way that will be compatible with multiple providers!
      elsif res.code.to_s.to_i == 500
        message.update(internal_status:"Initial API call returned 500.", message_id: res.body)
        RetryApiJob.perform_later(message, provider[:alternate_uri].to_json)
      end
    end

  end
end
