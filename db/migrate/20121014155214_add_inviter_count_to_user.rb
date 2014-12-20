class AddInviterCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitees_count, :integer, :default => 0
  end
end
