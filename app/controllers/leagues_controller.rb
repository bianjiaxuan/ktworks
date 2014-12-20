# -*- coding: utf-8 -*-
class LeaguesController < ApplicationController
  before_filter :must_logged_in
  
  def my_leagues
    @leagues=League.where("status in(1,2) and (usera_id=#{current_user.id} or userb_id=#{current_user.id})").order("updated_at desc").limit(10)
  end
  
  def search_friends
    name = params['name']
    #@users=[]
    @users = User.where("nickname like '#{name}%' or email like '#{name}%'").limit(5)
        
    respond_to do |format|
      format.js
    end
  end
  
  def invite
    user_id=params[:user_id]
    if league=League.create_by_usera_and_userb(current_user.id,user_id,League::LEAGUE_TYPES_TEMP)
      league.update_attribute(:status, 2)
      result=1
    else
      result=0
    end
    #puts "#{result}======invite=result======="
    render :text => result
  end  
  
  def invite_check
    if params[:user_id].to_i == current_user.id
      result = 2
      render :text =>result and return      
    end
    league_a= League.where("status>0 and usera_id=#{current_user.id} and userb_id=#{params[:user_id]}")
    league_b= League.where("status>0 and userb_id=#{current_user.id} and usera_id=#{params[:user_id]}")
    if league_a.present?||league_b.present?
      result = 0
    else
      result = 1
    end
    render :text =>result
  end
  
  def edit
    @league=League.find(params[:id])
  end
  
  def update_league
    @league=League.find(params[:id])
    
    if params[:league][:avatar] && params[:league][:avatar].size > 1024 * 1024
      flash[:error] = "上传的图片超过系统限定的1mb"
      return redirect_to edit_league_path(@league)
    end
   
    
    
    is_saved = @league.update_attributes(params[:league])

    if is_saved
      flash[:notice] = "更新成功"
    else
      #@league.errors.messages
      flash[:error] = "更新出错"
    end

    return redirect_to edit_league_path(@league)
  end
  
  def check_name
    result=1
    league=League.find_by_name(params[:name])
    result=0 if league && league.id != params[:id].to_i
    render :text =>result
  end
  
  def ignore
    league=League.find(params[:id])
    league.update_attributes(:status=>3)
    return redirect_to my_leagues_path
  end
  
  def accept
    league=League.find(params[:id])
    league.update_attributes(:status=>1,:league_type=>League::LEAGUE_TYPES_STEADY)
    return redirect_to my_leagues_path
  end
end

