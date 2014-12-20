class AddReginToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :region, :string
  end
end
