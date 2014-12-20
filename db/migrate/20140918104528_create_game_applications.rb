class CreateGameApplications < ActiveRecord::Migration
  def change
    create_table :game_applications do |t|
      t.integer :user_id
      t.integer :game_id
      t.timestamps
    end
  end
end
