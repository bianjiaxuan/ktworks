# -*- coding: utf-8 -*-
class GamesController < ApplicationController
  before_filter :must_logged_in, only: [:list, :registration,:one_slide,:score]

  def index
    puts "------#{controller_name}----#{action_name}-------------"
    @games = Game.order("date desc").page(params[:page]).per(9)
    #@exps = InfoUrl.find_all_by_usage('game_exp', limit: 3)
    #@images = InfoUrl.find_all_by_usage ('game_image')
    #@intros = InfoUrl.find_all_by_usage ('game_intro')

    #@video = InfoUrl.find_by_usage ('game_video')
    #@announce = InfoUrl.find_by_usage ('game_announce')
  end

  def scene
    @game = Game.where("date = ? and url = ?","#{params[:year]}-#{params[:month]}-#{params[:day]}",params[:url]).first
    if @game.present?
      gv=GameVedio.where(:game_id => @game.id).first
      @game_vedio="#{gv.id}|#{gv.uri}" if gv && gv.check_vedio?
      @users = User.find_by_sql "select u.nickname,u.id from users u where exists
                (select r.user_id from rounds r where r.user_id=u.id and r.game_id=#{@game.id}) "
    end
  end

  def slide
    which = params[:which] #up or down
    cur_gv_id=params[:game_vedio_id]
    #filter some game vedio
    ids=GameVedio.find_by_sql("select id from game_vedios g where exists
             (select game_id from game_vedios g2 where g2.game_id=g.game_id and g2.id=#{cur_gv_id})")
    if ids.size > 0
      ids.map! {|a| a.id }
      cur_idx= ids.index(cur_gv_id.to_i)
      cur_gv_id= ids.fetch(Game.ary_slide?(ids, which, cur_idx))
    end
    gv = GameVedio.find(cur_gv_id)
    flag = gv.check_vedio? unless gv.nil?
    #删除视频处理
    while !flag do
      puts "再选一个吧。。。#{cur_gv_id} 杯具了"
      cur_gv_id= ids.fetch(Game.ary_slide?(ids, which, ids.index(cur_gv_id.to_i)))
      gv = GameVedio.find(cur_gv_id)
      flag = gv.check_vedio? unless gv.nil?
    end
    @game_vedio="#{gv.id}|#{gv.uri}" if flag
    respond_to do |format|
      format.js
    end
  end
  #某一个人比赛视频展示
  def one_slide
    which = params[:which] #up or down
    cur_gv_id=params[:game_vedio_id]
    begin
      #filter someone vedio
      ids=GameVedio.find_by_sql("select id from game_vedios g where exists
             (select r.game_vedio_id from game_records r where r.user_id=#{current_user.id} and r.game_vedio_id=g.id)")
      if ids.size > 0
        ids.map! {|a| a.id }
        cur_idx= ids.index(cur_gv_id.to_i)
        cur_gv_id= ids.fetch(Game.ary_slide?(ids, which, cur_idx))
      end
      gv = GameVedio.find(cur_gv_id)
      flag = gv.check_vedio? unless gv.nil?
      #删除视频处理
      while !flag do
        puts "再选一个吧。。。#{cur_gv_id} 杯具了"
        cur_gv_id= ids.fetch(Game.ary_slide?(ids, which, ids.index(cur_gv_id.to_i)))
        gv = GameVedio.find(cur_gv_id)
        flag = gv.check_vedio? unless gv.nil?
      end
      if flag
        score=GameRecord.find_by_sql("select score from game_records where game_vedio_id=#{cur_gv_id} and user_id=#{current_user.id}").first.score
        @game_vedio="#{gv.id}|#{gv.uri}|#{score}"
      end

    rescue
      puts "one_slide error;"
    end
    respond_to do |format|
      format.js
    end
  end

  def list
    @games = Game.find_all_by_opened(true)
  end

  def registration
    return redirect_to confirm_phone_path, notice: '请您填写您的手机号。' if current_user.phone.blank?
    return redirect_to send_code_path, notice: '请您验证您的手机号！' unless current_user.varified

    game = Game.find(params[:game_id])
    if game.blank?
      redirect_to games_list_path, notice: '提交参数错误'
      return
    end

    round = Round.first(conditions: {game_id: game.id, user_id: current_user.id})
    unless round.blank?
      return redirect_to games_list_path, notice: "您已经报名了这个比赛！您的比赛验证码为：#{round.varified_code}"
    end

    round = Round.new
    round.game = game
    round.user = current_user
    round.generate_code
    unless round.sendto current_user.phone, "感谢您报名参加街头足球PannaKO挑战赛。您的参赛验证码：#{round.varified_code}。请在现场出示本短信入场。【#{game.city}-#{game.place}@#{game.date.strftime('%Y-%m-%d')}-#{game.time_start.strftime('%H:%M')}~#{game.time_end.strftime('%H:%M')}】"
      return redirect_to games_list_path, notice: '参数错误'
    end
    round.save
    @round = round
  end

  def rank
    @scores = User.where("id != ?",123).limit(10).order("socres desc")
  end

  def scores_list
    hash = {}
    search = params['search']
    valid_keys = ['gender', 'age_group', 'province', 'city', 'area']
    search.each { |k, v| hash[k] = v if (v.present? && valid_keys.include?(k)) }
    @scores = User.joins(:profile).where(:user_profiles => hash).order('scores DESC').limit(10)
    respond_to do |format|
      format.js
    end
  end

   def league_scores_list
    hash = {}
    search = params['search']
    valid_keys = ['province', 'city', 'area']
    search.each { |k, v| hash[k] = v if (v.present? && valid_keys.include?(k)) }
    @scores = League.joins(:usera).where(:users => hash).where("league_type='#{League::LEAGUE_TYPES_STEADY}'").order('scores DESC').limit(10)
    respond_to do |format|
      format.js
    end
  end

  #用户评分裁判前检查是否已经评过分；1可以评分
  def check_score
    result = 0
    gr=GameRecord.find_by_game_vedio_id_and_user_id(params[:game_vedio_id],current_user.id)
    result= (gr.score > 0 ? 0 : 1)  unless gr.nil?
    render :text => result
  end

  #给裁判评分
  def score
    gr=GameRecord.find_by_game_vedio_id_and_user_id(params[:game_vedio_id],current_user.id)
    gr.update_attribute("score",params[:score])  unless gr.score > 0
    render :text => 1
  end

  def show
    @game = Game.find(params[:id])
    render :layout => "new_application"
  end

  def join
    if request.post?
      if user_signed_in?
        application = GameApplication.where(:game_id =>params[:id].to_i,:user_id => current_user.id).first
        if application.blank?
          GameApplication.create(:user_id => current_user.id, :game_id => params[:id])
          render :js => "window.location.reload()"
        else
          render :js => "alert('您已经报过名了')"
        end
      else
        render :js => "alert('请先登录')"
      end
    end
  end

  def invite
    if request.post?
      if user_signed_in?
        mobile = params[:mobile]
        game = Game.find(params[:gameid])
        friend = current_user.phone.present? ? current_user.phone : current_user.nickname
        msg = "您的好友#{friend}想和你来一场KT足球,http://www.ktfootball.com/games/show?id=#{game.id}"
        #msg = "您的好友#{friend}想和你来一场KT足球赛,时间:#{game.time_start.to_date.to_s}, 赛事名称:#{game.name||''}【http://www.ktfootball.com/games/show?id=#{game.id}】"
        #msg = "手机号:#{current_user.phone || current_user.nickname},想和你来一场1v1 2v2 KT足球赛。时间:#{game.time_start.to_date.to_s},地点:#{game.place} 赛事名称:#{game.name} 参与链接：http://www.ktfootball.com/games/show?id=#{game.id},想了解最新最火的KT足球？快上微信服务号搜索：KT足球".encode("utf-8")
        #return render text: msg
        SMS3.sendto mobile,msg
        render :js => "alert('发送成功')"
      else
        render :js => "alert('请先登录')"
      end
    end
  end
end
