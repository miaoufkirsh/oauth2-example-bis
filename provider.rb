require "bundler/setup"
require "sqlite3"
require "active_record"
require "oauth2/provider"
require "oauth2/router"
require 'sinatra/base'
require 'thin'
require 'logger'
OAuth2::Provider.realm = 'Opos oauth2 provider'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "test.db", :pool => 25)
ActiveRecord::Migrator.migrate('db')
ActiveRecord::Base.logger = Logger.new('test.log')

class User < ActiveRecord::Base
  include OAuth2::Model::ResourceOwner
  include OAuth2::Model::ClientOwner
end

#hash describes the permissions
PERMISSIONS = {
  'read_notes' => 'Read all your notes'
}

# password credential method
OAuth2::Provider.handle_passwords do |client, login, password|
  user = User.find_by_login(login)
  if user.password==password
    puts "acces"
    user.grant_access!(client)
  else
    nil
  end
end


class MyApp < Sinatra::Base
  dir = File.expand_path(File.dirname(__FILE__))

  set :static, true
  set :public, dir + '/public'
  enable :logging
  set :views,  dir + '/views'
  enable :sessions
  
  # for register client
  get '/oauth/apps/new' do
    @client = OAuth2::Model::Client.new
    erb :new_client
  end

  post '/oauth/apps' do
    @client = OAuth2::Model::Client.new(params)
    @client.save ? erb(:show_client) : erb(:new_client)
  end
  
  #for authorize
  [:get, :post].each do |method|
  __send__ method, '/oauth/authorize' do
    puts params
    @owner  = User.find_by_id(session[:user_id])
    @oauth2 = OAuth2::Provider.parse(@owner, request)
    
    
    if @oauth2.redirect?
      redirect @oauth2.redirect_uri, @oauth2.response_status
    end

    headers @oauth2.response_headers
    status  @oauth2.response_status

    @oauth2.response_body || erb(:login)
  end

  
  post '/oauth/allow' do
    @user = User.find_by_id(session[:user_id])
    @auth = OAuth2::Provider::Authorization.new(@user, params)

    if params['allow'] == '1'
      puts "acces granted"
      @auth.grant_access!
    else
      puts "acces denied"
      @auth.deny_access!
    end
    redirect @auth.redirect_uri, @auth.response_status
  end

  post '/login' do
    @user = User.find_by_login(params[:login])
    if @user.password==params[:password]
      @oauth2 = OAuth2::Provider.parse(@user, request)
      session[:user_id] = @user.id
      erb(@user ? :authorize : :login)
    else
      redirect '/oauth/authorize'
    end
  end
  
  # user creation
  get '/users/new' do
    @user = User.new
    erb :new_user
  end

  post '/users/create' do
    @user = User.create(params)
    if @user.save
      erb :create_user
    else
      erb :new_user
    end
  end
  
  # ressource
  
  get '/' do
    erb :home
  end
  
  get '/me' do
    puts request.inspect
    token = OAuth2::Provider.access_token(nil, [], request)
    puts token.inspect
    if token.valid?
      JSON.unparse('username' => token.owner.login)
    else
      JSON.unparse('error' => 'Keep out!')
    end
  end
  
end
 
  run! if app_file == $0
end
