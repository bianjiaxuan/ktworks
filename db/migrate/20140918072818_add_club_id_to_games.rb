class AddClubIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :club_id, :integer
    add_index :games, :club_id
  end
end
