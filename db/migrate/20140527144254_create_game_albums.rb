class CreateGameAlbums < ActiveRecord::Migration
  def change
    create_table :game_albums do |t|
      t.integer :game_id
      t.integer :user_id
      t.string :face_file_name
      t.string :face_content_type
      t.integer :face_file_size

      t.timestamps
    end
  end
end
