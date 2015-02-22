class List < ActiveRecord::Base
  has_many :items
  belongs_to :user

  
  def add item_name, list_id, user_id
    Item.create! item_name: item_name, list_id: list_id, user_id: user_id
  end


  # def add_item item_name
  #   # if list belongs to user, add items to that list.
  #   i = Item.where(item_name: item_name).first_or_create!
  #   items << i
  # end

  
end