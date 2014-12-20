# -*- coding: utf-8 -*-
class Admin::ClubsController < AdminController
  inherit_resources
  def index
    @items = Club.eager_load(:inviter).order('lives_count desc').page(params[:page]).per(20)  
  end
  
  def create
    create! do |success, fail|
      success.html {
        redirect_to :back
      }
      fail.html {
        @items = Club.order('id DESC').page(params[:page]).per(20)
        render :index
      }
    end
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to :back
      }
      fail.html {
        render :index
      }
    end
  end

end
