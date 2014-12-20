class AddIsJudgeToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_judge, :boolean, :default => false
  end
end
