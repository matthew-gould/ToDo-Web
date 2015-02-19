class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :due_date
      t.string :completed
      t.integer :list_id
    end
  end
end
