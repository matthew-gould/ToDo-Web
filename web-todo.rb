require 'sinatra/base'
require "pry"

require "./db/setup"
require "./lib/all"

# web address: http://localhost:4567

class Webtodo < Sinatra::Base
  # set :bind, '0.0.0.0'
  # set :port, '3000'

  
  def current_user
    # username = request.env["HTTP_AUTHORIZATION"]
    # User.find_or_create_by! name: username
    u = User.first
    return u
  end

  get '/lists' do
    current_user.lists.order(name: :asc).to_json
  end

  get '/items' do
    @user_items = current_user.items
    erb :todo
  end

  get '/lists/:name' do
    list = current_user.lists.find_by name: params[:name].downcase.capitalize
    @user_items = list.items.where(completed: false)
    @list_name = params[:name]
    @current_user = current_user.name.capitalize
    # list.to_json
    erb :todo
  end

  post '/lists/:list_name' do
    list = current_user.lists.find_or_create_by! name: params[:list_name].downcase.capitalize
    item = list.add params["item_name"], list.id, current_user.id
    item.to_json
  end

  post '/items/:id' do # need to add some functionality so only items on user's lists can be modified.
    item = current_user.items.find_by id: params[:id]
    item.due params["due_date"]
    item.to_json
  end

  post '/items/:id' do
    item = current_user.items.find_by id: params[:id]
    if params["completed"]
      item.complete!
    end
    item.to_json
  end

  get '/next' do
    item = current_user.items.where("due_date is not null").order("RANDOM()").first
      if item == nil
        current_user.items.where(completed: false).to_json
      end
  end

  get '/search' do
    search_param = params['search']
    item = current_user.items.where("item_name like '%#{search_param}%'")
    item.to_json
  end




  
end  

Webtodo.run!

# HTTParty.post("http://localhost:4567/lists", body: {name: 'test', item_name: 'test1'}, headers: {"Authorization" => "matt"})
# HTTParty.get("http://localhost:4567/lists/chores", body: {item_name: 'laundry'}, headers: {"Authorization" => "matt"})
# HTTParty.post("http://localhost:4567/lists/groceries", body: {item_name: 'tea'}, headers: {"Authorization" => "matt"})
# HTTParty.patch("http://localhost:4567/items/19", body: {due_date: 'Feb. 25th'}, headers: {"Authorization" => "matt"})
# HTTParty.delete("http://localhost:4567/items/18", body: {completed: 'true'}, headers: {"Authorization" => "matt"})
# HTTParty.get("http://localhost:4567/lists/next", headers: {"Authorization" => "matt"})
# HTTParty.get("http://localhost:4567/search", body: {search: "homework"}, headers: {"Authorization" => "matt"})


