class AddUserIdToGameVedio < ActiveRecord::Migration
  def change
    add_column :game_vedios, :user_id, :integer,:default=>0
  end
end
