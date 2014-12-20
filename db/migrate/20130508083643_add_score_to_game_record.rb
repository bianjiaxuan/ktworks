class AddScoreToGameRecord < ActiveRecord::Migration
  def change
    add_column :game_records, :score, :integer,:default => 0
  end
end
