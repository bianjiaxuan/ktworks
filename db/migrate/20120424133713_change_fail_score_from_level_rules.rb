class ChangeFailScoreFromLevelRules < ActiveRecord::Migration
  def change
    rename_column :level_rules, :fail_score, :draw_score
  end
end
