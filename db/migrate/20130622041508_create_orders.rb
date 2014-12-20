class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer  :user_id, :default => 0
      t.integer  :scores, :default => 0
      t.integer  :gift_id, :default => 0
      t.string   :gift_name, :default => 0
      t.integer  :status,:default => 0
      t.string   :receive_by, :default => ""
      t.string   :phone, :default=> ""
      t.string   :address, :default=> ""
      t.datetime :send_day
      
      t.timestamps
    end
  end
end
