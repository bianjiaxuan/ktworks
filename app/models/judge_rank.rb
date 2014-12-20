class JudgeRank < ActiveRecord::Base
  
  belongs_to :user, class_name: "User"
  #定时任务：计算裁判积分 凌晨1点做
  def self.judge_rank_score
    uday = Time.new.strftime("%Y-%m-%d")
    self.game_record_score!
    users = User.find_by_sql("select id from users where is_judge=true")
    users.each do |u|
      jr=JudgeRank.find_by_user_id(u.id)
      if jr
        jr.scores=jr.scores + GameVedio.judge_score(u.id) 
        jr.day=uday
      else
        jr=JudgeRank.new(:user_id=>u.id,:scores=>GameVedio.judge_score(u.id),:day=>uday)
      end
      jr.save
    end
  end
  
  #定时任务－不要直接调用－在JudgeRank.update_judge_score前
  def self.game_record_score!
    uday = Time.new.strftime("%Y-%m-%d")
    GameVedio.update_all("updated_at='#{uday}',score_flag=true","score_flag=false and created_at < date_sub(now(),interval 7 day)")
    GameRecord.update_all("score=5", 
      "game_vedio_id in(select id from game_vedios where updated_at='#{uday}' and score_flag=true) and score=0" )
  end
  
end
