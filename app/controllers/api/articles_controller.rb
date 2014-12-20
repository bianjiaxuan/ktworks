class Api::ArticlesController < Api::BaseController
  def index
    @articles = Article.apps.page(params[:page]).per(10)
  end

  def show
    @article = Article.find(params[:id])
  end

  def game_intro
    @host="#{request.protocol}#{request.host_with_port}"
    @articles = Article.game_intros.page(params[:page]).per(10)
    render 'index'
  end

  def game_terms
    @article = Article.game_routes.first
    render 'show'
  end
end

