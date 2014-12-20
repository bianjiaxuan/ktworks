class CreateBags < ActiveRecord::Migration
  def change
    create_table :bags do |t|
      t.string :code,:default=>''
      t.string :url,:default=>''

      t.timestamps
    end
    add_index :bags, :code, :unique => true
  end
end
