class AddNameToBag < ActiveRecord::Migration
  def change
    add_column :bags, :name, :string,:default=>''

  end
end
