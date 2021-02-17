require 'net/http'

class HitApiJob < ApplicationJob
  queue_as :default

  def perform(message)
    data = Message.providerData
    req = Net::HTTP::Post.new(data[:uri], 'Content-Type' => 'application/json')
    req.body = {message: message.message, to_number: message, callback_url: message.callback_url}.to_json
    res = Net::HTTP.start(data[:uri].hostname, data[:uri].port, :use_ssl => data[:uri].scheme == 'https') do |http|
      http.request(req)
    end

    # In case something unexpected occurs with JSON parsing
    begin
      message_id = JSON.parse(res.body)['message_id']
    rescue
    else
      if res.code.to_s.to_i == 200
        message.update(message_id: message_id)
        # Possibly write in a way that will be compatible with multiple providers!
      elsif res.code.to_s.to_i == 500
        puts "Hit 500 to Retry"
        uri = URI(Message.setURI(data[:alternate_provider]))
        Message.retry(message, uri)
      end
    end

  end
end
