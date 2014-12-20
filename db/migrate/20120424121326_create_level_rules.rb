class CreateLevelRules < ActiveRecord::Migration
  def change
    create_table :level_rules do |t|
      t.integer :grade1
      t.integer :grade2
      t.integer :win_score
      t.integer :fail_score

      t.timestamps
    end
  end
end
