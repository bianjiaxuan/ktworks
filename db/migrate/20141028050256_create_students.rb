class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :country
      t.string :sex
      t.string :phone
      t.string :email
      t.string :height
      t.string :weight
      t.string :idcard
      t.date :birthday
      t.date :join_date
      t.string :address
      t.string :parents_contact

      t.string :contact_type
      t.string :expectation

      t.has_attached_file :avatar

      t.integer :user_id

      t.timestamps
    end
    add_index :students, :user_id
  end
end
