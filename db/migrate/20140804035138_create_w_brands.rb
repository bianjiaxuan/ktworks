class CreateWBrands < ActiveRecord::Migration
  def change
    create_table :w_brands do |t|
      t.string :name,null: false
      t.string :ename
      t.string :logo
      t.text :content
      t.integer :sort, default: 0
      t.timestamps
    end
  end
end
