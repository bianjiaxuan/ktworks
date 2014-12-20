class AddScoreFlagToGameVedio < ActiveRecord::Migration
  def change
    add_column :game_vedios, :score_flag, :boolean,:default=>0

  end
end
