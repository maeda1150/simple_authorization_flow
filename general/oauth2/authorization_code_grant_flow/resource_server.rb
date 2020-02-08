require 'webrick'

resource_port = ENV['SAF_RESOURCE_SERVER_URI'].match(/\Ahttp:\/\/localhost:(?<port>.+?)\z/)[:port].to_i
server = WEBrick::HTTPServer.new :Port => resource_port

class UserInfo < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    if request.query['access_token'] == ENV['SAF_AUTH_TOKEN']
      response.status = 200
      response['Content-Type'] = 'text/plain'
      response.body = ENV['SAF_USER_SUB']
    else
      response.status = 400
      response['Content-Type'] = 'text/plain'
      response.body = 'invalid access token'
    end
  end
end

server.mount '/user_info', UserInfo
server.start
