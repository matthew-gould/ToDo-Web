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
    # username = request.env["HTTP_AUTHORIZATION"]
    u = User.last
    return u
  end

  get '/lists' do
    current_user.lists.order(name: :asc).to_json
  end

  get '/lists/:name' do
    g = current_user.lists.find_by name: params[:name]
    g.items.find_by(completed: false).to_json
    g.to_json
  end

  post '/lists/:list_name' do
    g = current_user.lists.find_or_create_by! name: params[:list_name]
    a = g.add params["item_name"], g.id
    a.to_json
  end

  patch '/items/:id' do
    g = Item.find_by id: params[:id]
    g.due params["due_date"]
    g.to_json

    # g = current_user.lists
    # a = g.items.find_by id: params[:id]
    # a.due params["due_date"]
    
  end

  
end  

Webtodo.run!

# HTTParty.post("http://localhost:4567/lists", body: {name: 'test', item_name: 'test1'})
# HTTParty.get("http://localhost:4567/lists/newlist", body: {item_name: 'fuck1'})
# HTTParty.post("http://localhost:4567/lists/newlist", body: {item_name: 'fuck1'})
# HTTParty.patch("http://localhost:4567/items/19", body: {due_date: 'Feb. 25th'})


