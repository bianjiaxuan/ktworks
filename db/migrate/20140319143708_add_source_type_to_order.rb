class AddSourceTypeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :source_type, :integer,:default => 0

  end
end
