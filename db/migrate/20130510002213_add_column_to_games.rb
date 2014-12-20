class AddColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :user_id, :integer,:default=>0

  end
end
