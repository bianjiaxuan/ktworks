# -*- coding: utf-8 -*-
class Api::GameVediosController < Api::BaseController
  def index
    @vedios = GameVedio.page(params[:page]).per(10)
  end

  def show
    @vedio = GameVedio.find(params[:id])
  end

  def post_vedio
    @result = GameVedio.create_vedio_by_params_info(params)
    render :json => @result
  end
end
