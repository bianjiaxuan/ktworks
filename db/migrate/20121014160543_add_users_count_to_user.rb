class AddUsersCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :users_count, :integer, :default => 0
  end
end
