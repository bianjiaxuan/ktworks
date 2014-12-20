class CreateInfoUrls < ActiveRecord::Migration
  def change
    create_table :info_urls do |t|
      t.string :usage, null: false
      t.string :url
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
