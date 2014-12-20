class AddManyColumnsToNewPlant < ActiveRecord::Migration
  def change
    add_column :new_plants, :other_a, :string
    add_column :new_plants, :other_b, :string
    add_column :new_plants, :other_c, :string
    add_column :new_plants, :other_d, :string
    add_column :new_plants, :other_e, :string
  end
end
