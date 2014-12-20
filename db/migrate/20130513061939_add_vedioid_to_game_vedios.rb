class AddVedioidToGameVedios < ActiveRecord::Migration
  def change
    add_column :game_vedios, :vedio_id, :string, :default => ''
    
  end
end
