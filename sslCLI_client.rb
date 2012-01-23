require 'oauth2'
require 'highline/import'
require 'openssl'
# do not verify the certificate 
# for debug purpose 
# http://stackoverflow.com/questions/4528101/ssl-connect-returned-1-errno-0-state-sslv3-read-server-certificate-b-certificat
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# initialization

CLIENT_ID = '1kprcbmq7lcy4elpobhr7duz9'
CLIENT_SECRET = 'bnnclbuil6tav92kk9jt6xk70'
REDIRECT_URI = 'http://localhost:8080/oauth2/callback'

SITE_URL = 'https://0.0.0.0:4567'

client = OAuth2::Client.new(CLIENT_ID,CLIENT_SECRET, {:site => SITE_URL, :token_url => '/oauth/authorize'})

begin
  username = ask("Enter your username:  ") { |q| q.echo = true }
  password = ask("Enter your password:  ") { |q| q.echo = "*" }
  token = client.password.get_token(username, password, {:redirect_uri => REDIRECT_URI},{:mode=>:header, :header_format=>"OAuth %s", :param_name=>"oauth_token"})
rescue => e
 puts e.description
 retry
end
puts "Acces granted"

begin 
  response = token.get('/me')
  puts response.body
rescue =>e
   puts e.description
   puts e.response.body
end
