class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :scores,:default=>0
      t.integer :grade,:default=>0
      t.integer :usera_id,:default=>0
      t.integer :userb_id,:default=>0

      t.timestamps
    end
  end
end
