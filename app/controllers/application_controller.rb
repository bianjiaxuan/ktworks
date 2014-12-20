# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!

  after_filter :god_of_rescue
  protect_from_forgery
  before_filter { params.permit! }

  RANK_LIST_HIGHER_SIZE = 4
  RANK_LIST_LOWER_SIZE = 5
  RANK_LIST_SIZE = RANK_LIST_HIGHER_SIZE + RANK_LIST_LOWER_SIZE + 1

  def render_404
    render '/404.html', status: 404, layout: false
  end

  def render_500 exception=nil
    @title = '500 网页出错'
    @exception = exception
    params[:html_class] = 'render_500'
    logger.error '500: ' << request.url.to_s
    logger.error '500: ' << exception.to_s
    Thread.new do
      UserMailer.report_exception(request, exception).deliver
    end
    render '/500.html', status: 500, layout: false
  end

  def self.rescue_errors
    rescue_from Exception, RuntimeError, with: :render_500
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: :render_404
  end
  rescue_errors unless Rails.env.development?

  private

  def scores(user)
    score = user.scores
    higher_scores = User.where("scores > ?", score).order('scores, id').limit(9).reverse
    lower_scores = User.where("scores <= ? and nickname != ?", score, user.nickname).order('scores DESC, id desc').limit(9)

    high_size = [higher_scores.size, RANK_LIST_HIGHER_SIZE].min
    low_size  = [lower_scores.size, RANK_LIST_SIZE - 1 - high_size].min
    high_size = [higher_scores.size, RANK_LIST_SIZE - 1 - low_size].min

    scores = higher_scores[-high_size..-1] + [user] + lower_scores[0..low_size-1]
    Rails.logger.error "UsersController::myspace > Rank_list_size_error current_user=#{user.id} \n #{p sscores}\n" if (scores.size != 10) and (User.all.size >= 10)

    scores
  end

  def league_scores?
    League.joins(:usera).where("league_type='#{League::LEAGUE_TYPES_STEADY}'").order('scores DESC').limit(10)
  end

  def get_new_plant
    @new_plant = NewPlant.where(indentify: 'kicktempo_2026_info').first
  end

  protected

  def must_logged_in
    session["user_return_to"] = request.url
    redirect_to "/newhome/login", notice: '你必须先登录！' if current_user.nil?
  end

  def god_of_rescue
  rescue => e
    redirect_to root_path, notice: '数据出错，请重试。', alert: e.to_s
  end

  def set_new_plant
    @new_plant = true
  end

  def after_sign_in_path_for(resource)
    profile = current_user.profile
    puts "#{profile.gender.nil?}----#{profile.birthday.nil?}"
    if profile.gender.nil? or profile.birthday.nil?
      profile_change_path
    else
      root_path
    end
  end

  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

  def check_access_token(w_service)
    if w_service.app_id.present? && w_service.app_secret.present?
      if w_service.access_token.blank?
        w_service.update_access_token
      else
        if Time.now > w_service.access_token_expire_time
          w_service.update_access_token
        end
      end
    end
  end

  def get_wx_user wx_id,token,w_user,sync_avatar=false
    r = JSON.parse(RestClient.get("https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{token}&openid=#{wx_id}&lang=zh_CN"))
    error = r["errcode"]
    if error.blank?
      w_user.subscribe = r["subscribe"] || ""
      if r["nickname"].present?
        regex = /[\u{40ee}-\u{9fa5}a-zA-Z]/
        _nickname = r["nickname"].scan(regex).join
        puts r["nickname"]
        w_user.nickname = _nickname || Time.now.to_i.to_s
      else
        w_user.nickname = Time.now.to_i.to_s
      end
      w_user.sex = r["sex"] || ""
      w_user.city = r["city"] || ""
      w_user.country = r["country"] || ""
      w_user.province = r["province"] || ""
      w_user.language = r["language"] || ""
      w_user.headimgurl = r["headimgurl"] || ""
      if r["subscribe_time"].present?
        w_user.subscribe_time = Time.at(r["subscribe_time"].to_i)
      end
      begin
        w_user.save
      rescue
        w_user.nickname = r["nickname"] + Time.now.to_i.to_s
        w_user.save
      end
      user = w_user.user
      user.sync_w_user_info(sync_avatar) if user.present?
    end
  end
end


# module BCrypt
#  class Password < String
#     def initialize(raw_hash)
#       if valid_hash?(raw_hash)
#         self.replace(raw_hash)
#         @version, @cost, @salt, @checksum = split_hash(self)
#       else
#         raise Errors::InvalidHash.new("invalid hash 2223,split: #{raw_hash.split('$')},size: #{raw_hash.size} ,#{raw_hash.to_s}")
#       end
#     end
#   end
# end