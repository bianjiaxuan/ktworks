# encoding: utf-8
class NewPlantController < ApplicationController
  before_filter :set_new_plant
  before_filter :get_new_plant, only: [:donate, :kicktempo_story, :support_our_plant]

  def index
    @shows = InfoUrl.where(usage: '2026_intro').limit(2)
    @supports_count = NewPlant.where(indentify: 'kicktempo_2026_info').first.try(:support_counter).to_i
  end

  def kicktempo_story
    @recommend_arts = Article.recommend_arts(@new_plant) unless params[:page]
    @stroy_articlas = Article.new_plant_stroys.page(params[:page]).per(20)
  end

  def support_kicktempo
    counter = NewPlant.where(indentify: 'kicktempo_2026_info').first
    @supports_count = counter.try(:support_counter).to_i + 1
    counter.increment!(:support_counter, 1)
    redirect_to support_our_plant_path
  rescue
    redirect_to support_our_plant_path
  end

  def school_list
    @provinces = SchoolItem.group('province')
  end

  def donated_citys
    cities = SchoolItem.where(province: params[:province]).group('city')
    render json: cities.collect(&:city)
  end

  def donated_schools
    schools = SchoolItem.where(city: params[:city])
    render json: schools.collect(&:name)
  end

  def gas_intro
  	@article = Article.where(title: '什么是气场').first || Article.new(title: '什么是气场')
    render 'articles/show'
  end

  def company
  	@article = Article.where(title: params[:companyname]).first || Article.new(title: params[:companyname])
    render 'articles/show'
  end

  def donate
    @message = Message.new
    @list = @new_plant.thanks_people.split("#")
  end

  def about_us
    @message = Message.new
    @donate_message = DonateMessage.new
  end

  def send_message
    @message = Message.new(params[:message])
    if @message.save
      flash[:notice] = "捐赠成功"
    else
      flash[:error] = "捐赠失败"
    end
    redirect_to about_us_path
  end

  def create_donate_message
    @message = DonateMessage.new(params[:message])
    if @message.save
      flash[:notice] = "捐赠成功"
    else
      flash[:error] = "捐赠失败"
    end
    redirect_to about_us_path
  end

  def plant_news
    @news_articlas = Article.news.page(params[:page]).per(20)
  end
end
