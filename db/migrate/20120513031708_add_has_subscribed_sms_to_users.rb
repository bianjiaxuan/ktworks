class AddHasSubscribedSmsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :has_subscribed_sms, :boolean, :default => true
  end
end
