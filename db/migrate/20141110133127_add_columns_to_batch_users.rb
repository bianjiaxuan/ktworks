class AddColumnsToBatchUsers < ActiveRecord::Migration
  def change
    add_column :batch_users, :vip_count, :integer
  end
end