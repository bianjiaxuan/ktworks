class AddGameIndex < ActiveRecord::Migration
  def change
    add_index :games, :city
    add_index :games, :country
  end
end
