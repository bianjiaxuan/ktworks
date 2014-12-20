# -*- coding: utf-8 -*-
class Admin::ScoresController < AdminController

  def index
    redirect_to admin_games_path, notice: '请选择当前比赛！' if @current_game.blank?
  end

  def submit
    return redirect_to admin_games_path, notice: '请选择当前比赛！' if @current_game.blank?

    result = Game.scores_submit(params, @current_game)

    if result[:success] == true
      redirect_to admin_scores_path, notice: '分数修改成功！'
    else
      redirect_to admin_scores_path, notice: result[:notice]
    end

  end

  def list
    #return redirect_to admin_games_path if params[:nickname].nil? || params[:round_date].nil?
    sql = "select r.* from rounds r,users u where r.user_id=u.id "
    sql << " and u.nickname like '#{params[:nickname]}%' " if params[:nickname].present?
    sql << " and DATE_FORMAT(r.created_at,'%Y-%m-%d')='#{params[:round_date]}'" if params[:round_date].present?
    @rounds = Kaminari.paginate_array(Round.find_by_sql(sql)).page(params[:page]).per(20)
  end

end
