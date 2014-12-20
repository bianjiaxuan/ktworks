class AddPriorityToGames < ActiveRecord::Migration
  def change
    add_column :games, :priority, :integer,:default=>0;

  end
end
