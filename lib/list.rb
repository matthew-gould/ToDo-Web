class List < ActiveRecord::Base
  has_many :items
  belongs_to :user

  def add_item *item_name
    i = Item.where(name: item_name).first_or_create!
    items << i
  end

  
end