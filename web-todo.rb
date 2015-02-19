require 'sinatra/base'
require "pry"

require "./db/setup"
require "./lib/all"

# web address: http://localhost:4567

class Webtodo < Sinatra::Base
  # set :bind, '0.0.0.0'
  # set :port, '3000'

  
  def current_user
    #username = params["user"]
    username = request.env["HTTP_AUTHORIZATION"]
    User.find_by_name username
  end

    post '/lists' do
      
    end






end  

Webtodo.run!