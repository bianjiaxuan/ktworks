class CreateProviencesData < ActiveRecord::Migration
  def change
    add_column :school_items, :province, :string
    add_column :school_items, :city, :string
  end
end
