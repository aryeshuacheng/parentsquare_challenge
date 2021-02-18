require 'net/http'

class RetryApiJob < ApplicationJob
  queue_as :default

  def perform(message, provider)
    parsed_provider = JSON.parse(provider)
    uri = URI::parse(parsed_provider)

    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {message: message.message, to_number: message, callback_url: message.callback_url}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    begin
      message_id = JSON.parse(res.body)['message_id']
    rescue
    else
      if res.code.to_s.to_i == 200
        message.update(internal_status: "Retry returned 200.", message_id: message_id)
      elsif res.code.to_s.to_i == 500
        message.update(internal_status: "Retry returned 500.", message_id: res.body)
      end
    end

  end
end
