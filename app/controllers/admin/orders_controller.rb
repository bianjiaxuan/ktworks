# -*- coding: utf-8 -*-
class Admin::OrdersController < AdminController
  inherit_resources
  respond_to :html, :json
  
  def index
    @orders = Order.order("created_at desc").page(params[:page]).per(15)
  end
  
end