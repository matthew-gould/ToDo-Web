class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :user do |t|
      t.string :name
      t.string :password
    end
  end
end
