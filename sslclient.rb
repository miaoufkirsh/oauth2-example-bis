require 'oauth2'
require 'sinatra'

# do not verify the certificate 
# for debug purpose 
# http://stackoverflow.com/questions/4528101/ssl-connect-returned-1-errno-0-state-sslv3-read-server-certificate-b-certificat
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# initialization

CLIENT_ID = '1kprcbmq7lcy4elpobhr7duz9'
CLIENT_SECRET = 'bnnclbuil6tav92kk9jt6xk70'
REDIRECT_URI = 'http://localhost:8080/oauth2/callback'

SITE_URL = 'https://0.0.0.0:4567'

class MyApp < Sinatra::Base

  Token = nil
  configure do
    # setting one option
    set :port, 8080
  end
  enable :sessions
  client = OAuth2::Client.new(CLIENT_ID,CLIENT_SECRET, {:site => SITE_URL, :token_url => '/oauth/authorize'})

  
  get '/oauth2/callback' do
    Token = client.auth_code.get_token(params[:code], {:redirect_uri => REDIRECT_URI},{:mode=>:header, :header_format=>"OAuth %s", :param_name=>"oauth_token"})
    redirect "/"
  end


  get '/' do 
    "<li><a href=#{client.auth_code.authorize_url({:redirect_uri =>  REDIRECT_URI, :scope => "read write"})}> Authorize the client </a></li>
     <li><a href=/me>visit my profile</a></li>"
  end
  
  get '/me' do  
    if !Token.nil?
      response = Token.get('/me')
      response.body
    end
  end

  run! if app_file == $0
end
