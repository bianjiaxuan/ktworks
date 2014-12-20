class AddAgentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agent, :boolean, :default => false

  end
end
