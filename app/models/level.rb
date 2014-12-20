class Level < ActiveRecord::Base
  # 根据积分取得等级
  def self.fetch_grade(score)
    level = Level.where('? >= min_score and ? < max_score', score, score).first
    level.grade unless level.nil?
  end
  
end
