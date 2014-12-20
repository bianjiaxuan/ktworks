class CreateJudgeRanks < ActiveRecord::Migration
  def change
    create_table :judge_ranks do |t|
      t.integer :user_id
      t.integer :scores,:default=>0
      t.string :day

      t.timestamps
    end
  end
end
