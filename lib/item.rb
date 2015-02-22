class Item < ActiveRecord::Base
  belongs_to :list
  belongs_to :user

  def due due_date
    update due_date: due_date
  end

  def complete!
    update completed: true
  end
end