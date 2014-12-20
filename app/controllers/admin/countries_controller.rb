# -*- coding: utf-8 -*-
class Admin::CountriesController < AdminController
  inherit_resources
  def index
    @items = Country.order('id DESC').page(params[:page]).per(20)
    @country = Country.new
  end

  def create
    create! do |success, fail|
      success.html {
        redirect_to :back,:notice => "修改成功"
      }
      fail.html {
        @items = Country.order('id DESC').page(params[:page]).per(20)
        render :index
      }
    end
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to :back,:notice => "修改成功"
      }
      fail.html {
        render :index
      }
    end
  end

end
