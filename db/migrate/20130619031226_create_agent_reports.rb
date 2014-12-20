class CreateAgentReports < ActiveRecord::Migration
  def change
    create_table :agent_reports do |t|
      t.string  :city, :default => ""
      t.integer :agent_id, :default => 0
      t.integer :invitees_count, :default => 0
      t.integer :reg_count, :default => 0
      t.string  :day, :default => ""
      t.timestamps
    end
  end
end
