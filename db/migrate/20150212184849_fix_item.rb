class FixItem < ActiveRecord::Migration
  def change
    change_column :items, :completed, :boolean, :default => false
  end
end
