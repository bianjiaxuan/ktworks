class AddScoreFlagToGameRecord < ActiveRecord::Migration
  def change
    add_column :game_records, :score_flag, :boolean,:default=>false

  end
end
