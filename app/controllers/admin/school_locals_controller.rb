# -*- coding: utf-8 -*-
class Admin::SchoolLocalsController < AdminController
  inherit_resources

  def index
    @school_locals = SchoolLocal.order('id DESC').page(params[:page]).per(20)
  end

  def create
    create! do |success, fail|
      success.html {
        redirect_to admin_school_locals_url
      }
    end
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to admin_school_locals_url
      }
    end
  end
end
