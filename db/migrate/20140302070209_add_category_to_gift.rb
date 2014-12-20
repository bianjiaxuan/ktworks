class AddCategoryToGift < ActiveRecord::Migration
  def change
    add_column :gifts, :category, :integer, :default=>0
  end
end
