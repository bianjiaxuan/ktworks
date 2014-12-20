# -*- coding: utf-8 -*-
class Admin::UsersController < AdminController
  def search

  end

  def index
    case params[:search_type]
    when 'email'
      @users = User.where('email LIKE ?', "%#{params[:keyword]}%")
    when 'phone'
      @users = User.where('phone LIKE ?', "%#{params[:keyword]}%")
    when 'nickname'
      @users = User.where('nickname LIKE ?', "%#{params[:keyword]}%")
    when 'vip'
      @users = User.where('is_vip = ?', true)
    else
      @users = User.order('admin DESC')
    end
    @users = @users.nil? ? User : @users
    hash = {}
    hash[:invitor_id] = params[:invitor_id] unless params[:invitor_id].blank?
    @users = @users.where(hash).order( params[:order_invitor] ? 'users_count DESC' : 'admin DESC').page(params[:page]).per(20)
  end

  # 设置成为会员
  def setvip
    @user = User.find(params[:id])
  end

  def updatevip
    user = User.find(params[:id])
    user.is_vip = true
    user.is_vip = false if params[:user][:vip_count].blank? && params[:user][:start_vip_time].blank?
    user.vip_count = params[:user][:vip_count].to_s.to_i
    user.start_vip_time = params[:user][:start_vip_time] if params[:user][:start_vip_time]
    user.end_vip_time = params[:user][:end_vip_time]    if params[:user][:end_vip_time]
    user.save

    return redirect_to admin_users_path
  end

  # 取消会员
  def cancelvip
    user = User.find(params[:id])
    user.update_attribute(:is_vip, false)
    return redirect_to :back
  end

  def admin
    user = User.find(params[:user_id].to_i)
    if user.agent
      redirect_to :back, notice: '代理人不能设置为管理员！'
      return
    end
    user.admin= user.admin? ? (false):(true)
    user.update_attribute(:admin, user.admin)
    redirect_to admin_users_path, notice: '设置成功！'
  end

  def setjudge
    @user = User.find(params[:id])
    @clubs = Club.where("end_date>?",Time.zone.now.beginning_of_day).order("created_at")
  end
  def judge

    df=/\A[12]\d{3}-[01]\d{1}-[0123]\d{1}\z/
    msg = '设置成功。'
    begin
      user = User.find(params[:id])
      msg="取消成功"  and  user.update_attributes(:is_judge=>"0",:judge_day=>nil,:judge_end_day=>nil) and redirect_to :back, notice: msg  and return  if params[:user][:judge_day].blank?
      msg = "出错了！日期格式：yyyy-mm-dd" and redirect_to :back, notice: msg  and return  if df.match(params[:user][:judge_day]).nil? or df.match(params[:user][:judge_end_day]).nil?
      user.update_attributes(:is_judge=>"1",:judge_day=>params[:user][:judge_day],:judge_end_day=>params[:user][:judge_end_day],:judgeclub_id => params[:user][:judgeclub_id] ) if params[:user][:judge_day] && params[:user][:judge_end_day]
    rescue => detail
      puts detail.backtrace.join("\n")
      msg ="有异常发生"
    end
    redirect_to :back, notice: msg
  end

  def agent_list
    @agents = User.where("agent=1").order("id").page(params[:page]).per(20)
  end

  def judge_list
    @judges = JudgeRank.order("scores desc").page(params[:page]).per(20)
  end

  def setagent
    @user = User.find(params[:id])
  end
  def agent
    msg="设置成功"
    df=/\A[12]\d{3}-[01]\d{1}-[0123]\d{1}\z/
    begin
      user = User.find(params[:id])
      if user.admin
        redirect_to :back, notice: '管理员不可以设置代理人。'
        return
      end

      msg="取消成功"  and  user.update_attributes(:agent=>"0",:agent_day=>nil,:agent_end_day=>nil) and redirect_to :back, notice: msg  and return  if params[:user][:agent_day].blank?
      msg = "出错了！日期格式：yyyy-mm-dd" and redirect_to :back, notice: msg  and return  if df.match(params[:user][:agent_day]).nil? or df.match(params[:user][:agent_end_day]).nil?
      user.update_attributes(:agent=>"1",:agent_day=>params[:user][:agent_day],:agent_end_day=>params[:user][:agent_end_day]) if params[:user][:agent_day] && params[:user][:agent_end_day]

    rescue => detail
      puts detail.backtrace.join("\n")
      msg ="有异常发生"
    end
    redirect_to :back, notice: msg
  end

  def new
    @user = BatchUser.new
    #@agents = User.where("agent=true or is_judge=true")
    @clubs = Club.where("end_date>?",Time.zone.now.beginning_of_day).order("created_at")
  end

  def tally

  end

  def day_top_scores
    some_day = params[:some_date] || Time.new.strftime("%Y-%m-%d")
    puts "---#{some_day}---"
    s = "select sum(score) top_score ,game_id,user_id from rounds "+
        " where date_format(created_at,'%Y-%m-%d') = '#{some_day}' "+
        " group by game_id,user_id order by top_score desc limit 1 "
    @rounds = Round.find_by_sql(s)
  end

  def day_rounds
    some_day = params[:some_date] || Time.new.strftime("%Y-%m-%d")
    puts "---#{some_day}---"
    s= "select count(user_id) user_count,count(user_id)/2 round_count,game_id from rounds where "+
      " date_format(created_at,'%Y-%m-%d') = '#{some_day}' group by game_id"
    @rounds = Round.find_by_sql(s)
  end

  def day_goals
    @some_day = params[:some_date] || Time.new.strftime("%Y-%m-%d")
    puts "---#{@some_day}---"
    s = "select sum(goals) goals,sum(pannas) pannas,sum(panna_ko) kt_count from rounds "+
        " where date_format(created_at,'%Y-%m-%d') = '#{@some_day}'"
    @rounds = Round.find_by_sql(s)
  end

  def day_games
    @some_day = params[:some_date] || Time.new.strftime("%Y-%m-%d")
    puts "---#{@some_day}---"
    s = " select count(distinct(g.id)) game_count,g.city from rounds r, games g "+
        " where r.game_id = g.id " +
        " and date_format(r.created_at,'%Y-%m-%d') = '#{@some_day}' " +
        " group by g.city,r.game_id"
    @games = Game.find_by_sql(s)
  end
  def batch_index
    user_identifier = params[:identifier]
    user_identifier = BatchUser.last.identifier if params[:identifier].nil?
    @users = User.where("email in (select email from batch_users where identifier='#{user_identifier}')").order("created_at asc").page(params[:page]).per(50)
  end

  def batch_signup
    agent_id  = params[:agent_id]
    batch_count  = params[:batch_count]
    set_vip_count = params[:set_vip_count]
    vip_start = params[:vip_start_date]
    vip_end = params[:vip_end_date]

    return redirect_to admin_users_new_path, notice: '请选择邀请人' if agent_id.blank?
    return redirect_to admin_users_new_path, notice: 'VIP设置要有起期和止期' if vip_start.present? && !vip_end.present? || !vip_start.present? && vip_end.present?
    ls=('a'..'z').to_a
    ls.delete("o")
    ls.delete("l")

    today = Time.now
    day_yymmdd=today.strftime("%y%m%d")

    identifier = "#{agent_id}_#{batch_count}_#{Time.new.to_i}"
    #a130928+seq
    start_seq=0
    pre_user=BatchUser.find_by_sql("select max(seq) seq from batch_users where created_at > str_to_date('"+day_yymmdd+"','%y%m%d')")
    start_seq = pre_user[0].seq+1 if pre_user[0].seq

    agent = User.find(agent_id)
    user_emails=[]
    ('1'.."#{batch_count}").to_a.each do |i|
      prefix_letter=ls[Random.rand(ls.size)]
      email = "#{prefix_letter}#{day_yymmdd}"
      bu = BatchUser.new()
      bu.seq = start_seq+i.to_i
      bu.password = "#{email}#{bu.seq}"
      bu.email = "#{bu.password}@ktz.cn"
      user_emails.push("'#{bu.email}'")
      bu.status=0
      bu.agent_id=agent_id
      bu.identifier = identifier
      bu.count = batch_count
      bu.vip_count = set_vip_count
      bu.save!()
      sign_up_vip(bu.email,bu.password,bu,agent)
    end
    redirect_to admin_users_batch_index_path
  end

  def sign_up(email,password)
    sign_up_vip(email,password,nil,nil)
  end

  def sign_up_vip(email,password,bu,agent)

    user = User.new()
    user.email = email
    user.nickname=password
    user.password=password
    user.password_confirmation=password
    user.source= User::SOURCE_BACKGROUND
    user.city = agent.city if agent.present?
    vip_start = nil
    vip_end =nil
    if bu.present?
      user.invitor_id= bu.agent_id
      user.start_vip_time = bu.vip_start
      user.end_vip_time = bu.vip_end
      user.vip_count = bu.vip_count
    end

    if vip_start.present? && vip_end.present?
      user.is_vip = 1
      user.start_vip_time = vip_start
      user.end_vip_time = vip_end
    end
    user.save
    #邮件确认
    #user.confirm!
  end

  def create
    @user = User.new(params[:user])
    if @user.phone.blank?
      @user.errors.add(:phone, "必须填写！" )
      return render 'new'
    end
    @user.password = Devise.friendly_token.first(6)
    @user.confirmed_at = Time.now
    @user.varified = true
    @user.sendto @user.phone, "感谢您参加KICK-TEMPO街头足球PK赛，您的账号是\"#{@user.email}\"，密码是\"#{@user.password}\"，欢迎您登陆www.kicktempo.cn查看您的比赛积分。"
    UserMailer.send_generated_password(@user).deliver
    if @user.save
      return redirect_to admin_users_path(search_type: 'email', keyword: @user.email)
    else
      return render action: :new
    end
  rescue => e
    redirect_to admin_users_path(email: @user.email), alert: e.to_s
  end

  def registration
    game = @current_game
    return redirect_to admin_games_path, notice: '请先选择比赛！' if game.nil?
    user = User.find(params[:user_id].to_i)
    return redirect_to admin_users_path, notice: '提交参数错误' if user.nil?

    round = Round.where(game_id: game.id, user_id: user.id).first
    return redirect_to admin_users_path(email: user.email), notice: "已经报名了这个比赛！比赛验证码为：#{round.varified_code}" unless round.blank?

    round = Round.new(game_id: game.id, user_id: user.id)
    round.generate_code
    return redirect_to admin_users_path(email: user.email), notice: '请先填写手机号' if user.phone.blank?
    unless round.sendto user.phone, "感谢您报名参加街头足球PannaKO挑战赛。您的参赛验证码：#{round.varified_code}。请在现场出示本短信入场。【#{game.city}-#{game.place}@#{game.date.strftime('%Y-%m-%d')}-#{game.time_start.strftime('%H:%M')}~#{game.time_end.strftime('%H:%M')}】"
      return redirect_to admin_users_path(email: user.email), notice: '参数错误'
    end
    round.save

    redirect_to admin_users_path(email: user.email), notice: '报名成功！'
  end

  def admission
    game_number = params[:number]
    return redirect_to admin_users_path, notice: '请填写参赛号码' if game_number.blank?
    game = @current_game
    return redirect_to admin_games_path, notice: '请先选择比赛' if game.nil?
    user = User.find(params[:user_id].to_i)
    return redirect_to admin_users_path, notice: '提交参数错误' if user.nil?
    round = Round.where(game_id: game.id, game_number: game_number).first
    return redirect_to admin_users_path(email: user.email), notice: '这个参赛号码已经使用过了' unless round.nil?

    Round.create!(game_id: game.id, user_id: user.id, game_number: game_number, varified: true)

    redirect_to admin_users_path(email: user.email), notice: '入场成功！'
  end

  def phone
    user = User.find(params[:user_id].to_i)
    return redirect_to admin_users_path, notice: '提交参数错误' if user.nil?

    user.phone = params[:phone]
    user.city = params[:city]
    user.save
    redirect_to admin_users_path, notice: '修改成功'
  end

  def area
    area = params[:area]
    return redirect_to admin_users_agent_list_path, notice: '请填写代理区域码' if area.blank?
    user = User.find(params[:user_id].to_i)
    return redirect_to admin_users_agent_list_path, notice: '提交参数错误' if user.nil?

    user.area = area
    user.save
    redirect_to admin_users_agent_list_path, notice: '修改成功'
  end

  def destroy
    user = User.find(params[:user_id].to_i)
    return redirect_to admin_users_path, notice: '提交参数错误' if user.nil?

    user.destroy
    redirect_to admin_users_path, notice: '删除成功'
  end

  # 手机短信订阅用户
  def subscribed_sms
    case params[:search_type]
    when 'email'
      @users = User.where('has_subscribed_sms = ? and email LIKE ?', true, "%#{params[:keyword]}%").order('id DESC').page(params[:page]).per(20)
    when 'phone'
      @users = User.where('has_subscribed_sms = ? and phone LIKE ?', true, "%#{params[:keyword]}%").order('id DESC').page(params[:page]).per(20)
    when 'nickname'
      @users = User.where('has_subscribed_sms = ? and nickname LIKE ?', true, "%#{params[:keyword]}%").order('id DESC').page(params[:page]).per(20)
    when 'vip'
      @users = User.where('has_subscribed_sms = ? and is_vip = ?', true, true).order('id DESC').page(params[:page]).per(20)
    else
      @users = User.where('has_subscribed_sms = ?', true).order('id DESC').page(params[:page]).per(20)
    end

    @selected_sms_users = SelectedSmsUsers.order("user_id DESC")
  end

  # 尚未短信订阅用户
  def unsubscribed_sms
    @users = User.where('has_subscribed_sms = ?', false).order('id DESC').page(params[:page]).per(20)
  end

  # 后台取消用户短信订阅
  def cancel_subscribed_sms
    user = User.find(params[:user_id].to_i)
    user.has_subscribed_sms = false
    user.save

    return redirect_to admin_users_subscribed_sms_path, notice: "#{user.nickname}已经取消短信订阅"
  end

  # 后台确定用户短信订阅
  def confirm_subscribed_sms
    user = User.find(params[:user_id].to_i)
    user.has_subscribed_sms = true
    user.save

    return redirect_to admin_users_subscribed_sms_path, notice: "#{user.nickname}已经成功短信订阅"
  end


  # 选定要发送短信的用户
  def check_sms
    unless SelectedSmsUsers.where(:user_id => params[:user_id]).exists?
      SelectedSmsUsers.create(:user_id => params[:user_id])
    end
    @selected_sms_users = SelectedSmsUsers.all

    render :nothing => true
  end

  # 反选取消要发送短信的用户
  def uncheck_sms
    if SelectedSmsUsers.where(:user_id => params[:user_id]).exists?
      selected_user = SelectedSmsUsers.find_by_user_id(params[:user_id])
      selected_user.destroy
    end
    render :nothing => true
  end

  # 选中发短信的用户
  def selected_sms
    @selected_sms_users = SelectedSmsUsers.order('user_id DESC')

    render :layout => false
  end


  # 取消发送短信用户
  def cancel_selected_sms
    selected_user = SelectedSmsUsers.find_by_user_id(params[:user_id])
    selected_user.destroy

    if params['current_page'].eql?('send_sms')
      return redirect_to :back
    else
      render :action => 'selected_sms', :layout => false
    end
  end

  def profile
    @user = User.find(params[:id])
  end


end
