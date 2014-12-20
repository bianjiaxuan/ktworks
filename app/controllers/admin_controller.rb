# -*- coding: utf-8 -*-
class AdminController < ApplicationController
  before_filter :must_logged_in
  before_filter :must_be_admin
  before_filter :set_current_game
  before_filter :get_new_plant
  after_filter :god_of_rescue_admin

  protected

  def must_be_admin
    redirect_to root_path, notice: '你必须以管理员身份登录！' unless current_user.admin?
  end

  def set_current_game
    @current_game = Game.find(session[:current_game_id].to_i) unless session[:current_game_id].nil?
    @current_game ||= Game.first
  rescue
    session[:current_game_id] = nil
    @current_game = nil
  end

  def god_of_rescue_admin
  rescue => e
    redirect_to admin_index_path, notice: '数据出错，请重试。', alert: e.to_s
  end

end
