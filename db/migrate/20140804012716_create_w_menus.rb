class CreateWMenus < ActiveRecord::Migration
  def change
    create_table :w_menus do |t|
      t.string :name, null: false
      t.integer :klass, default: 0
      t.integer :menu_type, default: 0
      t.string :url, default: ""
      t.string :key, default: ""
      t.integer :parent_id
      t.integer :sort, default: 0
      t.timestamps
    end
  end
end
