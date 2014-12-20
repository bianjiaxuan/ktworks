class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :city
      t.string :place
      t.date :date
      t.time :time_start
      t.time :time_end
      t.integer :checked_in, default: 0
      t.boolean :opened

      t.timestamps
    end
  end
end
