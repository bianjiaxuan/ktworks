class CreateSmsRecords < ActiveRecord::Migration
  def change
    create_table :sms_records do |t|
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
