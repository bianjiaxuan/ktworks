class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name, :default=>''
      t.integer :user_id
      t.integer :agent_id
      t.date :start_date

      t.timestamps
    end
  end
end
