class AddGameTypeToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :game_type, :integer, :default => 0

  end
end
