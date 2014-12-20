class GameVedio < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => 'game_records'
  has_and_belongs_to_many :leagues, :join_table => 'game_records', association_foreign_key: "user_id"
  belongs_to :game
  has_many :records,class_name: "GameRecord", primary_key: "id",foreign_key: "game_vedio_id"

  # attr_accessible :uri, :judger, :local, :time,:vedio_id,:game_id,:user_id
  validates_presence_of :uri, :judger, :local, :time,:game_id,:user_id
  default_scope -> { order('created_at DESC') }

  def self.create_vedio_by_params_info(params)
    user_error_message = ""
    if Game::GAME_TYPE_LEAGUE == params[:game_type].to_i
      league = true
    end
    user1 = league ? League.find(params[:uid1]) : User.find(params[:uid1])
    user_error_message << (league ? "没有找到联盟一" : "无法找到选手一;") if user1.blank?
    user2 = league ? League.find(params[:uid2]) : User.find(params[:uid2])
    user_error_message << (league ? "没有找到联盟二" : "无法找到选手二;") if user2.blank?
    return { :success => false, :message => user_error_message } if user_error_message.present?

    game_vedio = GameVedio.new(
      :vedio_id =>params[:uri],
      :uri=>params[:uri],
      :judger => params[:judger],
      :local  => params[:local],
      :time   => params[:time]
    )
    game_vedio.game_id= params[:game_id] if params[:game_id]
    game_vedio.user_id= params[:user_id] if params[:user_id]
    if league
      game_vedio.game_type = Game::GAME_TYPE_LEAGUE
      game_vedio.leagues << user1 << user2
    else
      game_vedio.users << user1 << user2
    end

    if game_vedio.save
      #提交视频后检查是否批量生成用户
      BatchUser.inviter!(user1) unless league
      BatchUser.inviter!(user2) unless league
      return { :success => true, :message => '视频提交成功。' }
    else
      return { :success => false, :message => game_vedio.errors.messages }
    end
  end

  def intro_info user_id = nil
    "#{vedio_time.strftime('%Y年%m月%d日')} #{users.first.nickname}与#{users.last.nickname}在#{local}进行比赛，裁判：#{judger}"
  end

  def self.game_record?(gv_id)
    gv = GameVedio.find(gv_id)
    grs=GameRecord.where(:game_vedio_id=>gv_id)
    if grs.size > 0
      r0 = Round.find_by_game_id_and_user_id_and_pair_id(gv.game_id,grs[0].user_id,grs[1].user_id)
      r1 = Round.find_by_game_id_and_user_id_and_pair_id(gv.game_id,grs[1].user_id,grs[0].user_id)
      str = "#{gv.vedio_time.strftime('%Y年%m月%d日')} "
      str << gv.game_type ==Game::GAME_TYPE_LEAGUE ? "#{grs[0].league.name}-" : "#{grs[0].user.nickname}-"
      str << "#{r0.score}" unless r0.nil?
      str << " Vs. "
      str << gv.game_type ==Game::GAME_TYPE_LEAGUE ? "#{grs[1].league.name}-" : "#{grs[1].user.nickname}-"
      str << "#{r1.score}" unless r1.nil?
      return str
    end
  end

  def vedio_time
    time || created_at
  end

  def uri
    uri="http://player.youku.com/embed/#{vedio_id}"
  end

  def check_vedio?
    uri="http://v.youku.com/v_show/id_#{vedio_id}.html"
    uri = URI(uri)
    res = Net::HTTP.get_response(uri)
    puts "check_vedio #{id}--#{vedio_id} code==#{res.code}"
    return res.code == '200'
  end

  def self.judge_score(user_id)
    score_sum= 0
    grs = GameRecord.find_by_sql ["select id,score,score_flag from game_records r where r.score_flag=false and exists(
      select id from game_vedios v where r.game_vedio_id=v.id
      and v.user_id= :User_id )",{:User_id=>user_id}]
    unless grs.nil?
      grs.each do |gr|
        gr.update_attribute(:score_flag,true)
        score_sum+=gr.score
      end
    end
    return score_sum
  end

  def self.count_referee_score? user_id
    score=0
    judge=JudgeRank.find_by_user_id(user_id)
    score=judge.scores if judge
    return score
  end
end
