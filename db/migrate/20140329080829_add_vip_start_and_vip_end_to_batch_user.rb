class AddVipStartAndVipEndToBatchUser < ActiveRecord::Migration
  def change
    add_column :batch_users, :vip_start, :date

    add_column :batch_users, :vip_end, :date
    
    add_column :batch_users, :identifier, :string,:default=>''

    add_column :batch_users, :count, :integer,:default=>0
  end
end
