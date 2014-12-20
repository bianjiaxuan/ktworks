class GameVediosController < ApplicationController
  before_filter :authenticate_user!
  def index
    search_hash = params[:user_id] ? { :user_id => params[:user_id] } : {}
    if params[:user_id]
      @game_vedios = User.find(params[:user_id]).game_vedios.page(params[:page]).per(4)
    else
      @game_vedios = GameVedio.where(:game_type=>0).page(params[:page]).per(4)
    end
  end
  
  def show
    gv = GameVedio.find(params[:id])
    @game_vedio="#{gv.id}|#{gv.uri}" 
  end
  
  def my_shows
    @game_vedios = User.find(current_user.id).game_vedios.page(params[:page]).per(7)
  end
 
end
