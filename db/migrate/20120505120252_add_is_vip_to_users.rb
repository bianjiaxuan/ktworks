class AddIsVipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_vip, :boolean
  end
end
