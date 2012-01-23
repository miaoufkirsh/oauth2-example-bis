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

SSL
---------------------------------
### generate a certificate
     openssl req -x509 -nodes -days 365 -newkey rsa:1024 -out ssl.crt -keyout ssl.key

### Usage
same as previous, but with sslprovider.rb, sslclient.rb and sslCLI_client.rb
