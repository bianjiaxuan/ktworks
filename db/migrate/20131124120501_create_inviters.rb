class CreateInviters < ActiveRecord::Migration
  def change
    create_table :inviters do |t|
      t.integer :user_id
      t.integer :invitees_count
      t.integer :lives_count

      t.timestamps
    end
  end
end
