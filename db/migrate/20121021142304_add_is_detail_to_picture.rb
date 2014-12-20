class AddIsDetailToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :is_detail, :boolean, :default => true
    remove_column :users, :is_detail
  end
end
