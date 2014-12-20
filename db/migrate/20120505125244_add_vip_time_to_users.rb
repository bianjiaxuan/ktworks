class AddVipTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :start_vip_time, :string
    add_column :users, :end_vip_time, :string
  end
end
