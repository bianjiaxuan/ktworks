# -*- coding: utf-8 -*-
class ArticlesController < InheritedResources::Base
  layout "new_application", only: [:index,:detail]

  def show
  	@article = Article.find(params[:id])
  	if @article.is_private
  		# authenticate_user!
  		if current_user.nil?
  			flash[:error] = "您需要登录后才能浏览本页；如果您尚未注册KICK TEMPO，请您先注册。"
  			authenticate_user!
  		end
  	end
  end

  def detail
    resource.update_attributes :views_count => resource.views_count + 1
  end
end
