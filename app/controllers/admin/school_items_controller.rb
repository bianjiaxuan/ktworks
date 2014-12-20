# -*- coding: utf-8 -*-
class Admin::SchoolItemsController < AdminController
  inherit_resources
  def index
    @school_items = SchoolItem.order('id DESC').page(params[:page]).per(20)
  end

  def create
    create! do |success, fail|
      success.html {
        redirect_to admin_school_items_url
      }
    end
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to admin_school_items_url
      }
    end
  end
end
