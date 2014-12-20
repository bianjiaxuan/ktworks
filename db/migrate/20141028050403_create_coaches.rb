class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.string :name
      t.string :country
      t.string :sex
      t.string :phone
      t.string :email
      t.string :height
      t.string :weight
      t.string :idcard
      t.date :birthday
      t.date :auth_date
      t.string :address

      t.string :goodat
      t.text :intro

      t.has_attached_file :avatar

      t.integer :user_id

      t.timestamps
    end
    add_index :coaches, :user_id
  end
end
