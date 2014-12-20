class AddClubToUser < ActiveRecord::Migration
  def change
    add_column :users, :judgeclub_id, :integer,:default => 0

  end
end
