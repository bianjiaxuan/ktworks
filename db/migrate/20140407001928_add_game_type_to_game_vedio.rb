class AddGameTypeToGameVedio < ActiveRecord::Migration
  def change
    add_column :game_vedios, :game_type, :integer, :default => 0

  end
end
