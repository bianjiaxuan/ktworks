class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name, :default=> ''
      t.text :desc
      t.integer :scores, :default => 0
      t.string :images, :default=> ''
      t.boolean :on, :default=>false

      t.timestamps
    end
  end
end
