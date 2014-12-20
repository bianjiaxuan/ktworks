# -*- coding: utf-8 -*-
class UsersController < InheritedResources::Base
  RANK_LIST_HIGHER_SIZE = 4
  RANK_LIST_LOWER_SIZE = 5
  RANK_LIST_SIZE = RANK_LIST_HIGHER_SIZE + RANK_LIST_LOWER_SIZE + 1

  before_filter :authenticate_user!, :except => [:connect_auths]
  respond_to :html, :json

  def myspace
=begin

    my_score = current_user.scores
    higher_scores = User.all(conditions: ["scores > ?", my_score], limit: 9, order: 'scores').reverse
    lower_scores = User.all(conditions: ["(scores <= ?) & (nickname <> ?)", my_score, current_user.nickname], limit: 9, order: 'scores DESC')

    high_size = [higher_scores.size, RANK_LIST_HIGHER_SIZE].min
    low_size  = [lower_scores.size, RANK_LIST_SIZE - 1 - high_size].min
    high_size = [higher_scores.size, RANK_LIST_SIZE - 1 - low_size].min

    @scores = higher_scores[-high_size..-1] + [current_user] + lower_scores[0..low_size-1]
    Rails.logger.error "UsersController::myspace > Rank_list_size_error current_user=#{current_user.id} \n #{p @scores}\n" if (@scores.size != 10) and (User.all.size >= 10)
=end
    @user = current_user
    @scores = scores(current_user)
    @announces = InfoUrl.find_all_by_usage('game_announce', limit: 3, order: 'updated_at DESC')
  end

  def confirm_phone
  end

  def invite
    @invite_url="#{sign_up_url}?invited_by=#{CGI::escape(current_user.nickname)}"
    @invite_url = "#{sign_up_url}" if @invite_url.size > 90
    #548>104)  1 / #548>176  2/#548>272 3
    #548>384)  4 / #548>496  5/#740>608 6
    #@qr = RQRCode::QRCode.new("#{@invite_url}", :size => 9, :level => 'q'.to_sym)
  end

  def varify_phone
    phone = params[:phone].to_i
    exist_phones = User.where("phone = ? and varified = ?", phone, true).first
    if exist_phones.present?
      return redirect_to confirm_phone_path, alert: '这个手机已经注册过了！'
    end
    current_user.phone = phone
    current_user.varified = false

    # 判断用户是否想接收手机短信
    current_user.has_subscribed_sms = params[:has_subscribed_sms]? true: false

    current_user.save

    redirect_to send_code_path
  end

  def send_code
    res = current_user.send_code
    return redirect_to confirm_phone_path, alert: '您的手机号不正确！' if res == :blank_phone
  end

  def varify_code
    code = params[:code]
    return redirect_to root_path, alert: '您输入的验证码有误！请重试！' unless current_user.varified_code == code
    current_user.varified = true
    current_user.save
    redirect_to root_path, notice: '验证成功！'
  end


  # 订阅或者退订手机短信
  def subscribe_sms
    @user = current_user
  end

  def myclubbers
    @user = current_user
    type = params[:type]
    manager = params[:manager]
    if @user.agent
      club =  Club.where("agent_id=#{@user.id}").select{|c| c.user_id == manager.to_i }
      redirect_to root_path unless club.present?
    elsif @user.is_judge
      redirect_to root_path unless @user.id == manager.to_i
    else
      redirect_to root_path
    end

    sql = "invitor_id=#{manager}"

    if "lives".eql?(type)
      sql << " and exists (select  r.user_id from rounds r where r.user_id=`users`.id )"
      @users = User.where(sql).page(params[:page]).per(20)
    else
      @users = User.where(sql).page(params[:page]).per(20)
    end
  end

  def myorders
    @user = current_user
    @orders=Order.where(:user_id=>current_user.id,:source_type=>0)
  end
  def varify_subscribe_sms
    # 判断用户是否想接收手机短信
    current_user.has_subscribed_sms = params[:has_subscribed_sms]? true: false

    current_user.save
    flash[:subscribed] = true

    redirect_to subscribe_sms_path
  end

  # 访问用户页面首页
  def home
    @user = User.find(params[:user_id].to_i)

    @scores = scores(@user)
    @league_scores=league_scores?
=begin
    if current_user.agent and @user.id == current_user.id
      sql1= "select count(*) as count from users where invitor_id=#{current_user.id}"
      @count_invite = User.find_by_sql(sql1)[0].count
      sql2= "select count(*) as count from users u where u.invitor_id=#{current_user.id} and exists (select  r.user_id from rounds r where r.user_id=u.id )"
      @count_round= User.find_by_sql(sql2)[0].count
    end

    if @user.id == current_user.id and (current_user.clubs.count>0)
       @clubs = Club.eager_load(:agency).eager_load(:inviter).order('lives_count desc').where("`clubs`.agent_id=#{current_user.id}") if current_user.agent
    end
=end
    if @user.id == current_user.id
      if @user.agent
        @clubs = Club.where("agent_id=#{@user.id}")
      elsif @user.is_judge
        @clubs = Club.where("user_id=#{@user.id}")
      end
      render 'home_my'
    else
      render 'home_other'
    end
  end

  def my_scores
    @user = current_user
  end

  private

  def scores(user)
    score = user.scores
    higher_scores = User.where("scores > ?", score).order('scores, id').limit(9).reverse
    lower_scores = User.where("scores <= ? and nickname != ?", score, user.nickname).order('scores DESC, id desc').limit(9)

    high_size = [higher_scores.size, RANK_LIST_HIGHER_SIZE].min
    low_size  = [lower_scores.size, RANK_LIST_SIZE - 1 - high_size].min
    high_size = [higher_scores.size, RANK_LIST_SIZE - 1 - low_size].min

    scores = higher_scores[-high_size..-1] + [user] + lower_scores[0..low_size-1]
    Rails.logger.error "UsersController::myspace > Rank_list_size_error current_user=#{user.id} \n #{p sscores}\n" if (scores.size != 10) and (User.all.size >= 10)

    scores
  end

  def league_scores?
    League.joins(:usera).where("league_type='#{League::LEAGUE_TYPES_STEADY}'").order('scores DESC').limit(10)
  end

end
