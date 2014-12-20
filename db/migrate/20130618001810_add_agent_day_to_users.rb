class AddAgentDayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :agent_day, :datetime

  end
end
