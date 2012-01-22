require 'oauth2'
require 'highline/import'

# initialization

CLIENT_ID = '1kprcbmq7lcy4elpobhr7duz9'
CLIENT_SECRET = 'bnnclbuil6tav92kk9jt6xk70'
REDIRECT_URI = 'http://localhost:8080/oauth2/callback'

SITE_URL = 'http://0.0.0.0:4567'

client = OAuth2::Client.new(CLIENT_ID,CLIENT_SECRET, {:site => SITE_URL, :token_url => '/oauth/authorize'})

username = ask("Enter your username:  ") { |q| q.echo = true }
password = ask("Enter your password:  ") { |q| q.echo = "*" }

token = client.password.get_token(username, password, {:redirect_uri => REDIRECT_URI},{:mode=>:header, :header_format=>"OAuth %s", :param_name=>"oauth_token"})

response = token.get('/me')
puts response.body
