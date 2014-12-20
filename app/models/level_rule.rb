class LevelRule < ActiveRecord::Base
  # 根据等级取得胜利的分数
  def self.fetch_win_score(grade1, grade2)
    LevelRule.where('grade1 = ? and grade2 = ?', grade1, grade2).first.win_score
  end
  
  # 根据等级取得平局的分数
  def self.fetch_draw_score(grade1, grade2)
    LevelRule.where('grade1 = ? and grade2 = ?', grade1, grade2).first.draw_score
  end
end
