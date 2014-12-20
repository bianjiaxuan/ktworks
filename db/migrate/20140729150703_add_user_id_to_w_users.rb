class AddUserIdToWUsers < ActiveRecord::Migration
  def change
    add_column :w_users, :user_id, :integer
    add_index :w_users, :user_id
  end
end
