class CreateNewPlants < ActiveRecord::Migration
  def change
    create_table :new_plants do |t|
      t.integer :support_counter
      t.string :indentify

      t.timestamps
    end
  end
end
