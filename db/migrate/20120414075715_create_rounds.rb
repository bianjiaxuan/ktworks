class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :pair_id
      t.string  :game_number
      t.boolean :varified, default: false
      t.integer :varified_code
      t.integer :goals, default: 0
      t.integer :pannas, default: 0
      t.boolean :panna_ko, default: false
      t.integer :fouls, default: 0
      t.integer :flagrant_fouls, default: 0
      t.boolean :abstained, default: false

      t.integer :score, default: 0
      t.integer :result, default: 0
      t.boolean :uploaded, default: false

      t.timestamps
    end
  end
end
