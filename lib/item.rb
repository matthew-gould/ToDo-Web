class Item < ActiveRecord::Base
  belongs_to :list

  def due due_date
    update due_date: due_date
  end
end