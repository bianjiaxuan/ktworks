class CreateBagTraces < ActiveRecord::Migration
  def change
    create_table :bag_traces do |t|
      t.string :code,:default=>''
      t.string :city,:default=>''
      t.string :location,:default=>''
      t.integer :user_id,:default=>0
      t.integer :game_id,:default=>0
      t.timestamps
    end
     add_column :bag_traces, :longitude, 'decimal(8,4)', :default => 0
     add_column :bag_traces, :latitude, 'decimal(8,4)', :default => 0
  end
end
