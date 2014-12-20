class AddAgentIdToBatchUsers < ActiveRecord::Migration
  def change
    add_column :batch_users, :agent_id, :string

  end
end
