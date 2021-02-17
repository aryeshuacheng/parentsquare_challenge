require 'net/http'

class Message < ApplicationRecord
  def self.setURI(alternate_provider)
    if alternate_provider == 1
      uri = "https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1"
    elsif alternate_provider == 2
      uri = "https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2"
    end
    uri
  end

  def self.retry(message, uri)
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {message: message.message, to_number: message, callback_url: message.callback_url}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    response_json = JSON.parse(res.body)

    if res.code.to_s.to_i == 200
      binding.pry
      message.update(message_id: 'Retry')
    else
      binding.pry
      message.update(message_id: "Both providers failed.")
    end
  end

  def self.providerData
    random = rand(99)

    if random <= 29
      uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1')
      alternate_provider = 2
    else
      uri = URI('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2')
      alternate_provider = 1
    end

   {uri: uri, alternate_provider: alternate_provider}
  end
end
