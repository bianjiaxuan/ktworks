# -*- coding: utf-8 -*-
class Admin::ArticlesController < AdminController
  inherit_resources
  respond_to :html, :json
  before_filter :selector, only: [:index, :new, :edit]
  
  def index
    @articles = Article.where('title LIKE ?', "%#{params[:title]}%").order('id DESC').page(params[:page]).per(20)
  end
  
  def new
    type = {
      'story' => 'kicktempo_story',
      'news' => 'kicktempo_news'
    }[params[:type]]
    @article = Article.new({art_types: type} )
  end
  
  def create
    Article.create(params[:article])
    redirect_to admin_articles_path
  end
  
  def update
    article = Article.find(params[:id])
    article.update_attributes(params[:article])
    redirect_to edit_admin_article_path(article)
  end

  # 设置为只能是有登录用户才能查看
  def set_visit
    article = Article.find(params[:id])
    if article.is_private
      article.is_private = false
    else
      article.is_private = true
    end
    article.save

    redirect_to :back
  end
  
  private
    def selector
      @selects = [
        ['APP文章', 'app_article'],
        ['APP比赛介绍', 'app_game_intro'],
        ['APP条款内容', 'app_game_routes'],
        ['足球梦故事', 'kicktempo_story'],
        ['2026相关新闻', 'kicktempo_news']
      ]
      @translation = Hash[@selects.map {|item| [item[1], item[0]] }]
    end

end
