class ChangeTimeStartFieldForGames < ActiveRecord::Migration
  def up
    change_column :games, :time_start, :datetime  
    change_column :games, :time_end, :datetime
  end

  def down
    change_column :games, :time_start, :time  
    change_column :games, :time_end, :time
  end
end
