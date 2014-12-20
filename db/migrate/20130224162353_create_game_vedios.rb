class CreateGameVedios < ActiveRecord::Migration
  def change
    create_table :game_vedios do |t|
      t.integer :game_id
      t.string :uri
      t.string :judger
      t.string :local
      t.datetime :time

      t.timestamps
    end
  end
end
