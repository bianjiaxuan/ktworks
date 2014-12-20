class CreateWMedia < ActiveRecord::Migration
  def change
    create_table :w_media do |t|
      t.string :name, null: false
      t.string :sub_name
      t.string :cover
      t.date :published_date
      t.text :content
      t.integer :sort, default: 0
      t.timestamps
    end
  end
end
