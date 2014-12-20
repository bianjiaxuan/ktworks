class AddHasSentToSmsRecords < ActiveRecord::Migration
  def change
   	add_column :sms_records, :has_sent, :boolean, :default => false
  end
end
