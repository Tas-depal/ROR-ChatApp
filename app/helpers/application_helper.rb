module ApplicationHelper
	require 'net/http'
  require 'uri'

  def avatar_image_tag(username)
    url = URI("https://ui-avatars.com/api/?name=#{username}&format=png")

    begin
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = "text/plain"
      response = https.request(request)
      data = response.read_body
    rescue Net::OpenTimeout
      retry
    end

    generated_image = Base64.encode64(data).gsub("\n", "")
    image_data = "data:image/png;base64,#{generated_image}"
  end
end
