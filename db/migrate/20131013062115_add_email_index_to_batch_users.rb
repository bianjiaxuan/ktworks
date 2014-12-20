class AddEmailIndexToBatchUsers < ActiveRecord::Migration
  def change
    add_index :batch_users, :email

  end
end
