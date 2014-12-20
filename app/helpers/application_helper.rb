#require 'iconv'
module ApplicationHelper

  def user_update_registration_path(resource, resource_name)
    if resource.email.blank? || resource.encrypted_password.blank?
      authuser_update_path
    else
      registration_path(resource_name)
    end
  end

  def omniauth_provider_to_cn provider
    mapper = {
      :weibo => '微博',
      :renren => '人人',
      :qq_connect => '腾讯QQ'
    }
    mapper[provider]
  end

  def resource_url_for path
   "#{request.protocol}#{request.host_with_port}#{path}"
  end

  def user_avatar_url user
    path = if user.try(:profile).try(:avatar_file_name).nil?
      '/assets/default_avatar.jpg'
    else
      user.profile.avatar.url
    end
    resource_url_for(path)
  end

  def league_avatar_url league
    path = if league.try(:avatar_file_name).nil?
      '/assets/default_avatar.jpg'
    else
      league.avatar.url
    end
    resource_url_for(path)
  end

  def user_qrcode_img_url user
    user.qrcode_img
  end

  def bag_qrcode_img_url bag
    bag.qrcode_img
  end

  def user_invite_qrcode_img user,url
    user.invite_qrcode_img url
  end


  def kicktempo_titile
    @new_plant.blank? ? 'KT足球 与你一起改变中国足球的气场！' : "2026计划-助力中国足球崛起"
  end

  def kicktempo_content
    @new_plant.blank? ? "KT足球官方网站：打破传统足球所有限制，线下对战，线上积分；真实的网络游戏；可以15倍速增加控球水平；音乐、足球、潮流文化结合的最新潮的足球运动！全球专利！打造全球联动赛事！使命：让中国成为世界足球第一大国！愿景：让足球范转地球！" : "2026计划是一项由KICKTEMPO发起的以帮助中国足球崛起为目的的超级计划。凝聚政府、企业、学校各方面资源，为学校捐赠便携式充气足球场（气场），开展校园足球PK赛，激发青少年学生参与足球的热情，增强中国足球的群众基础，创造全中国足球文化氛围，到2026年，让中国拥有5000万足球爱好者，成为真正的足球大国，让国足能在2026年冲刺世界杯冠军。该计划在2012年的目标是，通过企业捐赠1万个气场给学校。"
  end

  def url_for_2026
    Rails.env.production? ? 'http://2026.kicktempo.cn' : new_plant_path
  end

  def root_for_2026
    if Rails.env.production?
      @new_plant.blank? ? 'http://www.kicktempo.cn' : 'http://2026.kicktempo.cn'
    else
      root_path
    end
  end

  def valide_string untrusted_string
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    ic.iconv(untrusted_string)
  end

  def hm time
    time.strftime '%H:%M'
  end

  def ymd time
    "#{time.strftime('%Y')}/#{time.strftime('%m')}/#{time.strftime('%d')}"
  end

  def error_tag prop
    image_tag('wrong.png') if resource.errors.include? prop
  end

  def result res
    case res
    when 0 then "平"
    when 1 then "胜"
    when -1 then "负"
    else ""
    end
  end

  #检查比赛视频是否被删除
  def check_game_video?(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    return res.code == '200'
  end

  #裁判总分计算
  def count_referee_score?
    return "" unless current_user.is_judge
    user_id = current_user.id
    score = GameVedio.count_referee_score?(user_id)
    return " 裁判积分[#{score}]"
  end

  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

end
