class AddCityToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :city, :string
    add_index :clubs, :city
  end
end
