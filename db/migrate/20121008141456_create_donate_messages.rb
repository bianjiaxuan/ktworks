class CreateDonateMessages < ActiveRecord::Migration
  def change
    create_table :donate_messages do |t|
      t.string :name
      t.string :company
      t.string :phone
      t.string :address
      t.string :school_name
      t.string :student_count
      t.string :school_address
      t.string :contector
      t.string :contector_position
      t.string :content_phone
      t.string :donate_require
      t.string :remark

      t.timestamps
    end
  end
end
