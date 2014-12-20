class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :logo
      t.string :donate_count
      t.string :school_items
      t.string :intro
      t.string :site

      t.timestamps
    end
  end
end
