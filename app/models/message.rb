require 'net/http'

class Message < ApplicationRecord
  def self.retry(message, uri)
    puts "XYZ"
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {message: message.message, to_number: message, callback_url: message.callback_url}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    response_json = JSON.parse(res.body)

    if res.code.to_s.to_i == 200
      message_id = JSON.parse(res.body)['message_id']
      message.update(message_id: message_id)
    elsif res.code.to_s.to_i == 500
      message.update(message_id: message_id, tries:9999)
    end
  end

  def self.choose_provider
    random = rand(99)

    if random <= 29
      uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1')
      alternate_uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
    else
      uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
      alternate_uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1')
    end

   {uri: uri, alternate_uri: alternate_uri}
  end
end
