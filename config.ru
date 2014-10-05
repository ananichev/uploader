require 'app'

Rack::Handler::Thin.run Sinatra::Application, Port: 3000, Host: "0.0.0.0"
