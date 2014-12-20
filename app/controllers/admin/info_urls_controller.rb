# -*- coding: utf-8 -*-
class Admin::InfoUrlsController < AdminController
  inherit_resources
  respond_to :html, :json
  before_filter :set_selects

  def index
    @info_urls = InfoUrl.where("").page(params[:page]).per(15).order("`usage`")
  end

  private

  def set_selects
    @selects = [
      ['首页幻灯片', 'index_slide'], 
      ['首页展示', 'index_show'], 
      ['赛事照片', 'game_image'], 
      ['赛事介绍', 'game_intro'], 
      ['赛事视频', 'game_video'], 
      ['赛事公告', 'game_announce'], 
      ['赛事心得', 'game_exp'],
      ['2026介绍', '2026_intro'],
      ['导航_KT足球', 'nav_kt'],
      ['导航_KT团队', 'nav_team'],
      ['导航_KT历程', 'nav_timeline'],
      ['导航_KT文化', 'nav_culture'],
      ['导航_社会责任', 'nav_resposibility'],
      ['导航_2026介绍', 'nav_basics'],
      ['导航_2026故事', 'nav_legends'],
      ['导航_KT气场', 'nav_kt_qichang'],
      ['导航_KT足球赛', 'nav_kt_games'],
      ['导航_KT俱乐部', 'nav_kt_club'],
      ['导航_是范者星球', 'nav_shifanzhe'],
      ['顾问', 'nav_advisers'], 
      # ['足球梦故事', 'kicktempo_story'],
    ]
    @translation = Hash[@selects.map {|item| [item[1], item[0]] }]
  end

end
