# -*- coding: utf-8 -*-
class OrdersController < ApplicationController
  before_filter :must_logged_in
  
  def check_identity
    u= User.find(current_user.id)
    result = u.is_judge==true ? 1 : 0
    render :text => result
  end
  
  def check_scores
    result=0
    gift = Gift.find(params[:id])
     
    result=1                  if current_user.coins >= gift.scores
    result=current_user.coins if current_user.coins < gift.scores
    
    render :text => result
  end
  
  def address
    @order=Order.new
    @gift= Gift.find(params[:id])
  end
  
  def show
    @order = Order.find(params[:id])
    if current_user.id != @order.user_id
      redirect_to root_path, notice: '不可以查看不属于你的订单'
    end
  end
  
  def exchange
    gift=Gift.find(params[:order][:gift_id])
    #judge_rank = JudgeRank.find_by_user_id(current_user.id)
    puts "--exchange--#{current_user.id}-before-scores:#{current_user.coins}---兑换礼品积分:#{gift.scores}--#{Time.new}"
    order = Order.new(params[:order])
    order.user_id = current_user.id
    order.gift_name = gift.name
    order.scores = gift.scores
    order.status=1
    current_user.coins -= gift.scores
    if current_user.save && order.save
      redirect_to "/orders/#{order.id}/show"
    else
      puts "exchange--#{current_user.id}--#{params[:order][:gift_id]}---"
      redirect_to "/address/#{gift.id}",notice: '兑换出错，请重新兑换'
    end
  end
  
end