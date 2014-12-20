class AddCodeToGames < ActiveRecord::Migration
  def change
  	add_column :games,:code, :string
  	add_index :games, :code
  end
end
