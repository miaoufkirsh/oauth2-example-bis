OAuth2-example-bis
==========

Description
--------------------------------

An example of oauth2 flow

Installation
--------------------------------

      bundle install
      
Usage
--------------------------------
### Provider
run provider.rb and folow instructions (create an account and register a client)

### Web based flow
edit client.rb with client_id and client_secret
run client.rb

### Command line password flow
edit CLI_client.rb with client_id and client_secret
run CLI_client.rb

### Using Curl
get your token using password credential flow :
    
    curl -i http://localhost:4567/oauth/authorize     \
      -F grant_type=password    \
      -F client_id=<client_id>  \
      -F client_secret=<client_secret> \
      -F scope=read \
      -F username=<your_login> \
      -F password=<your_password>
      
you will get a response with an Acces Token
    
    {"access_token":"69est4qgt7by3id209o6weovt","scope":"read"}

then use the acces token for the query :
    
    curl -i http://localhost:4567/me -H "Authorization: OAuth <acces_token>"

SSL
---------------------------------
### generate a certificate
     openssl req -x509 -nodes -days 365 -newkey rsa:1024 -out ssl.crt -keyout ssl.key

### Usage
same as previous, but with sslprovider.rb, sslclient.rb and sslCLI_client.rb
for curl, use -k to avoid certificate verification
