class AddLocalToUser < ActiveRecord::Migration
  def change
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :area, :string
    remove_column :users, :local
  end
end
