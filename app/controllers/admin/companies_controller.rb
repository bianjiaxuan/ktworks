# -*- coding: utf-8 -*-
class Admin::CompaniesController < AdminController
  inherit_resources

  def index
    @companys = Company.order('id DESC').page(params[:page]).per(20)
  end

  def create
    create! do |success, fail|
      success.html {
        redirect_to admin_companies_url
      }
    end
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to admin_companies_url
      }
    end
  end

end
