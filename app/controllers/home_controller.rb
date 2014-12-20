# -*- coding: utf-8 -*-
class HomeController < ApplicationController

  def index
    @slides = InfoUrl.where(usage: 'index_slide',status:true).order("priority desc")
    @shows = InfoUrl.where(usage: 'index_show')
    case Rails.env
    when 'development'
      if request.host == 'rice.local' && params[:controller] == 'home' && params[:action] == 'index'
        load_2026_resourse
        render 'new_plant/index'
      end
    when 'production'
      if (request.host == '2026.kicktempo.cn' || request.host == '2026.ktfootball.com') && params[:controller] == 'home' && params[:action] == 'index'
        load_2026_resourse
        render 'new_plant/index'
      end
    else
      render 'home/index'
    end
  end

  def terms
  end

  def join_us
  end

  def business
  end

  def kt
    @page_title="关于KT足球"
    @nav="kt"
  end
  def navAsyn
    @section = params[:section]
    @shows = InfoUrl.where(usage: "nav_#{@section}")
    #games
    @fgames   = Game.where("date>='#{Time.new.strftime("%Y-%m-%d")}'") if "forecast" == @section
    @rgames   = Game.where("date<='#{Time.new.strftime("%Y-%m-%d")}'").order("date desc") if "review" == @section
    #rank
    @scores = User.where("id != ?",123).order("scores desc").limit(10) if "rank1"== @section
    # 老的算法抛弃
    # @scores = User.all(:conditions => ["id != ?", 123], limit: 10, order: 'scores DESC') if "rank1"== @section
    @scores = League.all(:conditions => ["league_type = ? and status=?", League::LEAGUE_TYPES_STEADY,1], limit: 10, order: 'scores DESC') if "rank2"== @section
    @judges   = JudgeRank.order("scores desc").page(params[:page]).per(10) if "judge_ranks" == @section
    @gifts    = Gift.where("category = 0") if "exchange"== @section
    @gifts    = Gift.where("category = 1") if "buy"== @section
    respond_to do |format|
      format.js
    end
  end

  def plan_2026;@page_title="2026计划";@nav="plan";end

  def agent_scopes
    @page_title="2026计划--布点城市";
    @nav="plan"
    @users = User.find_by_sql("select city,count(id) as count from users where city != '' group by city order by count desc limit 5")
    @agent_users = User.where("agent=1")
    #UserProfile.cities?
  end

  def agent_reports
    day= Time.new.strftime("%Y-%m-%d")
    reports = AgentReport.where(city: params[:city],day: day)
    render json: reports.collect{|r| "#{day} #{r.city}统计 总球员数#{r.reg_count}  其中代理#{r.user.nickname}球员人数#{r.invitees_count}"}
  end
  def game;@page_title="赛事信息";@nav="game";end
  def exchange
    @gifts = Gift.where("category=0")
  end
  def buy
    @gifts = Gift.where("category=1")
  end
  def rank
    @page_title="积分榜 一VS一"
    @nav="rank"
    #@scores = User.all(:conditions => ["id != ?", 123], limit: 10, order: 'scores DESC')
  end
  def judge_ranks
    @page_title="积分榜 裁判积分榜"
    @nav="rank"
    @judges = JudgeRank.where("").order("scores desc").page(params[:page]).per(10)
  end
  def rank1
    @page_title="积分榜 一VS.一"
    @nav="rank"
    @scores = User.all(:conditions => ["id != ?", 123], limit: 10, order: 'scores DESC')
  end
  def rank2
    @page_title="积分榜 二VS.二"
    @nav="rank"
    @scores = League.all(:conditions => ["league_type = ? and status=?", League::LEAGUE_TYPES_STEADY,1], limit: 10, order: 'scores DESC')
  end
  def cooperate;@nav="cooperate";end
  def agency;@nav="agency";end

  def time

  end

  private
  def load_2026_resourse
    @shows = InfoUrl.where(usage: '2026_intro').limit(2)
    @supports_count = NewPlant.where(indentify: 'kicktempo_2026_info').first.try(:support_counter).to_i
    get_new_plant
  end
end
