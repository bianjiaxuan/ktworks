class CreateGameRecords < ActiveRecord::Migration
  def change
    create_table :game_records do |t|
      t.integer :game_vedio_id
      t.integer :user_id

      t.timestamps
    end
  end
end
