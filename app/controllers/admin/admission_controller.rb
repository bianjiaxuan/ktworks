# -*- coding: utf-8 -*-
class Admin::AdmissionController < AdminController
  USER_GRADE_LENGTH = 1
  GAME_NUMBER_LENGTH = 3

  def index
    redirect_to admin_games_path, notice: '请选择当前比赛！' if @current_game.blank?
  end

  def entered
  end

  def set_youku
    omniauth = request.env['omniauth.auth']

    if omniauth.provider == 'Youku' && omniauth.info.name == 'KickTempo'
      @new_plant.update_attributes(
        :youku_username => omniauth.info.name,
        :youku_info => omniauth.info,
        :youku_token => omniauth.credentials.token,
        :youku_refresh_token => omniauth.credentials.refresh_token,
        )
      redirect_to admin_games_path, notice: '设置成功优酷账户成功。'
    else
      redirect_to admin_games_path, alert: "设置失败。优酷用户名#{omniauth.info.name} 不为 KickTempo!!"
    end
  end

  def admit
    nickname = params[:nickname]
    varified_code = params[:varified_code]

    if not ( user = User.find_by_nickname(nickname) )
      redirect_to admin_admission_path, notice: '你的昵称不正确！'
    elsif not (round = Round.first(conditions: {game_id: @current_game.id, user_id: user.id}))
      redirect_to admin_admission_path, notice: '你没有注册这个比赛！'
    elsif (round.varified_code.to_s != varified_code)
      redirect_to admin_admission_path, notice: '验证码错误！'
    elsif round.varified
      redirect_to admin_admission_path, notice: '你已经验证过了。'
    else
      @current_game.checked_in += 1
      round.game_number = user.grade.to_s.rjust(USER_GRADE_LENGTH, '0') + @current_game.checked_in.to_s.rjust(GAME_NUMBER_LENGTH, '0')
      round.varified = true

      round.save
      @current_game.save
      redirect_to admin_admission_entered_path(number: round.game_number), notice: '验证成功！'
    end
  end
end
