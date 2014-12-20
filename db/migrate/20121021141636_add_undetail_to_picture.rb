class AddUndetailToPicture < ActiveRecord::Migration
  def change
    add_column :users, :is_detail, :boolean, :default => true
  end
end
