class AddJudgeDayToUser < ActiveRecord::Migration
  def change
    add_column :users, :judge_day, :datetime

  end
end
