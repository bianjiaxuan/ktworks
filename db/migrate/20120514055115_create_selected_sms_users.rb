class CreateSelectedSmsUsers < ActiveRecord::Migration
  def change
    create_table :selected_sms_users do |t|
      t.integer   :user_id

      t.timestamps
    end
  end
end
