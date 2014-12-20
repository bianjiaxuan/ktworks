class AddVipCountAndJudgeEndDayAndAgentEndDayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vip_count, :integer, :default=>0

    add_column :users, :judge_end_day, :datetime

    add_column :users, :agent_end_day, :datetime

  end
end
