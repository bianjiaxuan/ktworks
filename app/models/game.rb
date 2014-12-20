# -*- coding: utf-8 -*-
class Game < ActiveRecord::Base
  belongs_to :club
  has_many :bag_traces
  has_many :rounds, dependent: :destroy
  has_many :game_albums, :class_name => 'GameAlbum'
  has_one  :user,:class_name => 'User',:primary_key=>'user_id',:foreign_key=>'id'

  has_attached_file :avatar, :styles => { :medium => "500x500>", :middle => "250x250>",  :thumb => "80x80>" }

  validates_attachment :avatar,# :presence => true,
    :content_type => { :content_type => ['image/png', 'image/jpg', 'image/gif', 'image/jpeg'] },
    :on => :upload_avatar

  validates_attachment_size :avatar, :less_than => 1.megabyte, :on => :upload_avatar

  validates :city, :country, :place,  :time_start, :time_end,:url, :presence => true
  validates_uniqueness_of :url,  :case_sensitive => false
  default_scope -> { order('priority DESC') }
  scope :opened, -> { where(:opened => true) }

  has_many :game_applications
  has_many :users, :through => :game_applications

  #1Vs.1 比赛
  GAME_TYPE_PLAYER = 0
  #2Vs.2比赛
  GAME_TYPE_LEAGUE = 1

  NEXT_UP = 'up'
  NEXT_DOWN='down'
  #数组上一个？下一个，返回指针位置
  def self.ary_slide?(ary,direction,cur)
    cur_idx= cur
    n_idx = (cur_idx+1) < ary.size ? (cur_idx+1):0 if NEXT_DOWN.eql?(direction)
    n_idx = (cur_idx-1) < 0 ? (ary.size-1) : (cur_idx-1) if NEXT_UP.eql?(direction)
    return n_idx
  end

  def open
    self.opened = true
    self.save
  end

  def close
    self.opened = false
    self.save
  end

  def self.scores_submit(params, game, model = 'web', code = nil)
    number1 = params[:number1]
    number2 = params[:number2]

    if Game::GAME_TYPE_LEAGUE == params[:game_type].to_i
      league = true
    end

    if model == 'web'
      round1 = Round.find_by_game_and_number(game.id, number1)
      round2 = Round.find_by_game_and_number(game.id, number2)
      return { :success => false, :notice => '选手一参赛号码有误！' } if round1.blank?
      return { :success => false, :notice => '选手二参赛号码有误！' } if round2.blank?

      if round1.user.id == round2.user.id
        return {:success => false, :notice => '比赛选手不能相同！' }
      end

      round1 = round1.dup if round1.uploaded
      round2 = round2.dup if round2.uploaded
    else
      uid1 = params[:uid1]
      uid2 = params[:uid2]
      error_messages = []
      error_messages << "对战用户不能相同" if uid1 == uid2
      if league
        error_messages << "找不到联盟一" if League.find(uid1).blank?
        error_messages << "找不到联盟二" if League.find(uid2).blank?
      else
        error_messages << "找不到用户一" if User.find(uid1).blank?
        error_messages << "找不到用户二" if User.find(uid2).blank?
      end

      return {:success => false, :notice => error_messages} if error_messages.present?

      round1 = Round.create_by_game_and_user_id(game.id, uid1)
      round1.update_column(:game_number, "app#{round1.id}")
      round2 = Round.create_by_game_and_user_id(game.id, uid2)
      round2.update_column(:game_number, "app#{round2.id}")
    end

    round1.goals = params[:goals1].to_i
    round2.goals = params[:goals2].to_i
    round1.fouls = params[:fouls1].to_i
    round2.fouls = params[:fouls2].to_i
    round1.flagrant_fouls = params[:flagrant_fouls1].to_i
    round2.flagrant_fouls = params[:flagrant_fouls2].to_i
    round1.pannas = params[:pannas1].to_i
    round2.pannas = params[:pannas2].to_i
    round1.panna_ko = ( params[:panna_ko1] == '1')
    round2.panna_ko = ( params[:panna_ko2] == '1' )
    round1.abstained = ( params[:abstained1] == '1' )
    round2.abstained = ( params[:abstained2] == '1' )

    if (round2.abstained or round1.panna_ko )
      round1.result = 1
      round2.result = -1
    elsif (round1.abstained or round2.panna_ko )
      round1.result = -1
      round2.result = 1
    elsif (round1.goals * 2 + round1.pannas) > (round2.goals * 2 + round2.pannas)
      round1.result = 1
      round2.result = -1
    elsif (round1.goals * 2 + round1.pannas) < (round2.goals * 2 + round2.pannas)
      round1.result = -1
      round2.result = 1
    else
      round1.result = 0
      round2.result = 0
    end

    # 当前用户
    user1 = league ? round1.league : round1.user
    user2 = league ? round2.league : round2.user

    # 先取出当前用户积分跟等级　
    user1_prev_grade = user1.grade
    user1_prev_scores = user1.scores
    user1_prev_coins = user1.coins   unless league
    user2_prev_grade = user2.grade
    user2_prev_scores = user2.scores
    user2_prev_coins = user2.coins   unless league
    round1_prev_score = round1.score
    round2_prev_score = round2.score

    result_score = 0
    result1_score = 0
    result2_score = 0

    if round1.result == 1
      #round1.score = 15
      #round2.score = 0
      result_score = LevelRule.fetch_win_score(user1.grade.to_i, user2.grade.to_i)
      user1.scores += result_score
      user2.scores += 1
      round1.score = result_score
      round2.score = 0
      user1.coins += result_score   unless league
      user2.coins += 1  unless league
    elsif round2.result == 1
      #round1.score = 0
      #round2.score = 15
      result_score += LevelRule.fetch_win_score(user2.grade, user1.grade)
      user1.scores += 1
      user2.scores += result_score
      round2.score = result_score
      round1.score = 0
      user1.coins += 1  unless league
      user2.coins += result_score   unless league
    elsif (round1.result == 0) and (round2.result == 0)
      #round1.score = 5
      #round2.score = 5
      result1_score += LevelRule.fetch_draw_score(user1.grade, user2.grade)
      result2_score += LevelRule.fetch_draw_score(user2.grade, user1.grade)
      user1.scores += result1_score
      user2.scores += result2_score
      user1.coins += result1_score  unless league
      user2.coins += result2_score  unless league
      round1.score = result1_score
      round2.score = result2_score
    end
    round1.uploaded = true
    round2.uploaded = true

    if league
      user1.grade =  Level.fetch_grade(user1.scores)
      user2.grade =  Level.fetch_grade(user2.scores)
      round1.game_type = Game::GAME_TYPE_LEAGUE
      round2.game_type = Game::GAME_TYPE_LEAGUE
      #League  after_save :update_uservipcounts
    else
      user1,round1 = evaluate_scores_and_grade!(user1,round1,user1_prev_scores,user1_prev_coins)
      user2,round2 = evaluate_scores_and_grade!(user2,round2,user2_prev_scores,user2_prev_coins)
      #check vip
      user1.vip_count= user1.vip_count.pred if user1.vip_count > 0
      user2.vip_count= user2.vip_count.pred if user2.vip_count > 0
      #user1.vip_count= user1.vip_count.pred if user1.is_in_vip_period && user1.vip_count > 0
      #user2.vip_count= user2.vip_count.pred if user2.is_in_vip_period && user2.vip_count > 0
    end

=begin
    # 根据用户积分，重新计算等级
    if user1.is_available_vip
      user1.grade = Level.fetch_grade(user1.scores)
    elsif user1.grade < 1
      user1.grade = Level.fetch_grade(user1.scores)
    else
      # 积分不再上升
      round1.score = 0
      user1.scores = user1_prev_scores
      user1.coins = user1_prev_coins
    end


    if user2.is_available_vip
      user2.grade = Level.fetch_grade(user2.scores)
    elsif user2.grade < 1
      user2.grade = Level.fetch_grade(user2.scores)
    else
      # 积分不再上升
      round2.score = 0
      user2.scores = user2_prev_scores
      user2.coins = user2_prev_coins
    end


    p 'sssssssssssssssssssssssss'
    p user1.scores
    p user2.scores
    p user1.grade
    p user2.grade
    p 'kkkkkkkkkkkkkkkkkkkkkkkkkkk'
=end

    # 用户绑定气场 & 赛事绑定气场
    if code.present?
      user1.binding_code = code if user1.binding_code.blank?
      user2.binding_code = code if user2.binding_code.blank?

      game.code = code
      game.save

      round1.code = code
      round2.code = code
    end

    user1.save
    user2.save

    round1.save
    round2.save
    round1.pair_id = round2.id
    round2.pair_id = round1.id
    round1.save
    round2.save

    return { :success => true, :notice => "" }
  end

  def self.dt_start (day,time)
    begin
      dtime = "#{day} #{time}".to_time().strftime('%Y-%m-%d %H:%M:%S')
    rescue
      dtime = "#{day}".to_time().strftime('%Y-%m-%d %H:%M:%S')
    end
    dtime
  end

  def self.dt_end (day,time)
    begin
      dtime = "#{day} #{time}".to_time().strftime('%Y-%m-%d %H:%M:%S')
    rescue
      dtime = "#{day} 22:00".to_time().strftime('%Y-%m-%d %H:%M:%S')
    end
    dtime
  end

  class << self
    def evaluate_scores_and_grade!(user,round,prev_scores,prev_coins)
      if user.is_available_vip
        user.grade = Level.fetch_grade(user.scores)
      elsif user.grade.to_i < 1
        user.grade = Level.fetch_grade(user.scores)
      else
        # 积分不再上升
        round.score = 0
        user.scores = prev_scores
        user.coins = prev_coins
      end
      [user,round]
    end
  end
end
