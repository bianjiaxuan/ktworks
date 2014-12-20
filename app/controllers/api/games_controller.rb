# -*- coding: utf-8 -*-
class Api::GamesController < Api::BaseController
  def index
    if search = params['search']
      hash = {}
      valid_keys = ['city', 'country']
      search.each { |k, v| hash[k] = v if (v.present? && valid_keys.include?(k)) }
    end
    @games = Game.where(search).where("priority > 0 or time_end > ?",Time.zone.now.beginning_of_day)
    # if params[:user_id].present?
    #   user = User.find(params[:user_id])
    #   if user.is_judge
    #     arr = user.clubs.map(&:bags).flatten.map(&:code).uniq
    #     @games = @games.where("code in (?)",arr)
    #   end
    # end
    @games = @games.page(params[:page]).per(10)
  end

  def city_games
    @games = Game.where("priority > 0 or time_end > ? and city = ?",Time.zone.now.beginning_of_day,params[:city]).order("updated_at desc").page(params[:page]).per(10)
  end

  def show
    @game = Game.find(params[:id])
  end

  def post_score
    @game = Game.find_by_id(params[:game_id])
    code = params[:code]
    return render :json => { :success => false, :message => '比赛查找失败！' }  if @game.blank?

    result = Game.scores_submit(params, @game, 'mobile', code)

    if result[:success] == true
      render :json => { :success => true, :message => '分数修改成功！' }
    else
      render :json => { :success => false, :message => result[:notice] }
    end
  end

  def rank
    if search = params['search']
      hash = {}
      valid_keys = ['gender', 'age_group', 'province', 'city', 'area']
      search.each { |k, v| hash[k] = v if (v.present? && valid_keys.include?(k)) }
      @scores = User.joins(:profile).where(:user_profiles => hash).order('scores DESC').limit(10)
    else
      @scores = User.where("id != ?", 123).order("scores desc").limit(10)
    end
  end

  def page_rank
    if search = params['search']
      hash = {}
      valid_keys = ['gender', 'age_group', 'province', 'city', 'area']
      search.each { |k, v| hash[k] = v if (v.present? && valid_keys.include?(k)) }
      @users = User.joins(:profile).where(:user_profiles => hash).order('scores DESC').page(params[:page]).per(10)
      if @users.count.zero?
        @users = User.where("id != ?", 123).order('scores DESC').page(params[:page]).per(10)
      end
    else
      if params[:user_id]
        c_user = User.find(params[:user_id])
        @users = User.where("id != ?", 123).order('scores DESC').page(params[:page]).per(10)
        if !@users.include?(c_user)
          @users.pop
          @users.concat([c_user])
          return
        end
      end
      @users = User.where("id != ?", 123).order('scores DESC').page(params[:page]).per(10)
    end

  end

  def page_league_rank
    if search = params['search']
      hash = {}
      valid_keys = ['gender', 'age_group', 'province', 'city', 'area']
      search.each { |k, v| hash[k] = v if (v.present? && valid_keys.include?(k)) }
      @leagues=League.joins(:usera).where(:users => hash).where("league_type='#{League::LEAGUE_TYPES_STEADY}'").order('scores DESC').page(params[:page]).per(10)
    else

      @leagues=League.where("
           league_type='#{League::LEAGUE_TYPES_STEADY}' and (
            usera_id='#{params[:user_id]}' or userb_id='#{params[:user_id]}')
        ").order('scores DESC').page(params[:page]).per(10)

    end
  end

  def citys
    #cs={}
    #UserProfile.cities?
    #$cities.each do |city|
    #  cs[URI.escape(city)]=URI.escape(city)  if city
    #end

    # render :json => Country.cities.inject({}){ |a,b| 
    #   a[URI.escape(b.name)] = URI.escape(b.name); a
    # },:status => 200

    if params[:country]
      #@citys = Game.where(:country => params[:country]).group(:city).select(:city)
      cities = Country.where(:kind => "city",:parent => params[:country])
    else
      cities = Country.cities
      # @citys = Game.group(:city).select(:city)
    end
    render :json => cities.inject({}){ |a,b| 
      a[URI.escape(b.name)] = URI.escape(b.name); a
    },:status => 200
  end

  def countrys
    #@countrys = Country.select(:name)
    # cs={}
    # $countries.each do |c|
    #   cs[URI.escape(c)]=URI.escape(c)
    # end
    render :json => Country.countries.inject({}){ |a,b| 
      a[URI.escape(b.name)] = URI.escape(b.name); a
    },:status => 200
  end

  def country_cities
    hash = Country.where("parent != ?","").group_by(&:parent)
    hash = hash.inject({}){|a,b| a[URI.escape(b.first)] = b.last.map{|n|URI.escape(n.name)}; a }
    render :json => { :data => hash }, :status => 200
  end

  def create_game
    if params[:game][:place].nil? || params[:game][:place].blank?
      render :json => { :success => false, :messages => "没有指定比赛场地" }
      return
    end
    params[:game].each do |k,v|
      params[:game][k]=URI.decode(v) unless v.nil?
    end
    params[:game][:url]="#{Time.now.strftime('%Y-%m-%d-%H%M%S%L')}"
    params[:game][:opened]=1
    #judge = User.find(params[:game][:user_id])
    #render :json => { :success => false, :messages => "裁判没有设置城市" } if judge.nil? || judge.city.blank?
    #params[:game][:city] = judge.city unless judge.nil? || judge.city.blank?
    if params[:game][:date].present?
      params[:game][:time_start] = Game.dt_start(params[:game][:date],params[:game][:time_start])
      params[:game][:time_end] = Game.dt_end(params[:game][:date],params[:game][:time_end])
    end
    games = Game.where("city=? and place=? and created_at>?",params[:game][:city],params[:game][:place],Time.zone.now.beginning_of_day)
    render :json => { :success => true, :game_id => games.first.id } and return if games.present? && games.first.present?

    @game = Game.new(params[:game])
    if @game.save
      render :json => { :success => true, :game_id => @game.id }
    else
      render :json => { :success => false, :messages => @game.errors.messages }
    end
  end

  def post_league
    league = League.where(usera_id: params[:user1_id],userb_id: params[:user2_id]).first
    if league.blank?
      league = League.create_by_usera_and_userb(params[:user1_id],params[:user2_id],League::LEAGUE_TYPES_TEMP)
      league_type = "TEMP"
    else
      league_type = "STEADY"
    end
    @users = league.users?
    usera = @users.first
    userb = @users.last
    @league = league

    render :json => [{
      :success => true,
      :league => @league.attributes.merge({ :avatar => @league.avatar.url }),
      :users => [
        { :user => { :id => usera.id, :avatar => usera.profile.avatar.url  } },
        { :user => { :id => userb.id, :avatar => userb.profile.avatar.url  } }
      ]
    }]

  end

  def bag_trace
    render :json => BagTrace.post_trace(params)
  end

  def post_face
    @user = User.find(params[:game_album][:user_id])
    if @user.nil?
      render :json => { :success => false, :message => "未授权用户" } and return
    end

    if params[:game_album].nil?
      render :json => { :success => false, :message => "忘记什么啦？" } and return
    end

    if params[:game_album][:face].size > 1024 * 1024
      render :json => { :success => false, :message => "图片太大了，1M" } and return
    end

    @game_album = GameAlbum.create(:user_id => @user.id)

    if @game_album.update_attributes(params[:game_album])
      render :json => { :success => true, :message => '更新成功。' }
    else
      render :json => { :success => false, :message => @game_album.errors.messages }
    end

  end

end
