class CreateWCities < ActiveRecord::Migration
  def change
    create_table :w_cities do |t|
      t.string :name, null: false
      t.string :ename
      t.string :cover
      t.text :content
      t.integer :sort, default: 0
      t.timestamps
    end
  end
end
