class AddParentToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :parent, :string, :default=>''
    add_column :countries, :kind, :string, :default=>''
  end
end
