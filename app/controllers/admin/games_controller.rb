# -*- coding: utf-8 -*-
class Admin::GamesController < AdminController
  inherit_resources
  respond_to :html, :json

   def index
    hash = {}
    hash[:city] = params[:city] unless params[:city].blank?
    @games = Game.where(hash).order('updated_at desc').page(params[:page]).per(20)
  end
  def create
    @game = Game.new(params[:game])
    @game.opened=true
    @game.user_id = current_user.id
    create!
  end

  def update
    params[:game][:user_id]=current_user.id
    update!
  end

  def open
    Game.find_by_id(params[:game_id].to_i).open
    redirect_to admin_games_path, notice: '开放比赛成功！'
  end

  def close
    Game.find_by_id(params[:game_id].to_i).close
    redirect_to admin_games_path, notice: '关闭比赛成功！'
  end

  def start
    session[:current_game_id] = params[:game_id]
    redirect_to admin_games_path, notice: '设定当前比赛成功！'
  end

  def finish
    session[:current_game_id] = nil
    redirect_to admin_games_path, notice: '当前比赛已结束！'
  end

  def destroy
    rounds = Round.where(game_id: params[:id].to_i)
    unless rounds.blank?
      rounds.each do |round|
        unless round.result == -1  then
          round.user.scores = round.user.scores - round.score
          # 根据用户积分，重新计算等级
          round.user.grade = Level.fetch_grade(round.user.scores)
          round.user.save
        end
        round.destroy
      end
    end

    game = Game.find(params[:id])
    game.destroy


    redirect_to :back

  end

end
