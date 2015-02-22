require 'sinatra/base'
require "pry"

require "./db/setup"
require "./lib/all"

# web address: http://localhost:4567

class Webtodo < Sinatra::Base
  # set :bind, '0.0.0.0'
  # set :port, '3000'

  
  def current_user
    username = request.env["HTTP_AUTHORIZATION"]
    User.find_or_create_by! name: username
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
    a = g.add params["item_name"], g.id, current_user.id
    a.to_json
  end

  patch '/items/:id' do # need to add some functionality so only items on user's lists can be modified.
    g = Item.find_by id: params[:id]
    g.due params["due_date"]
    g.to_json
  end

  delete '/items/:id' do
    g = Item.find_by id: params[:id]
    if params["completed"]
      g.complete!
    end
    g.to_json
  end

  get '/next' do
    a = current_user.items.where("due_date is not null").order("RANDOM()").first
    a.to_json
  end

  get '/search' do
  end




  
end  

Webtodo.run!

# HTTParty.post("http://localhost:4567/lists", body: {name: 'test', item_name: 'test1'}, headers: {"Authorization" => "matt"})
# HTTParty.get("http://localhost:4567/lists/newlist", body: {item_name: 'fuck1'}, headers: {"Authorization" => "matt"})
# HTTParty.post("http://localhost:4567/lists/Groceries", body: {item_name: 'cereal'}, headers: {"Authorization" => "matt"})
# HTTParty.patch("http://localhost:4567/items/19", body: {due_date: 'Feb. 25th'}, headers: {"Authorization" => "matt"})
# HTTParty.delete("http://localhost:4567/items/18", body: {completed: 'true'}, headers: {"Authorization" => "matt"})
# HTTParty.get("http://localhost:4567/lists/next", headers: {"Authorization" => "matt"})


