# -*- coding: utf-8 -*-
class GameAlbumsController < InheritedResources::Base
  before_filter :authenticate_user!
  respond_to :html, :json


  # 上传页面
  def face
  end

  # 上传
  def upload_face
    if params[:game_album].nil?
      flash[:error] = "你打算做什么呢？"
      return redirect_to face_game_albums_path
    end
    if params[:game_album][:face].size > 1024 * 1024
      flash[:error] = "上传的图片超过系统限定的1mb"
      return redirect_to face_game_albums_path
    end
   
    gameAlbum = GameAlbum.create(:game_id=>1,:user_id => current_user.id)
    is_saved = gameAlbum.update_attributes(params[:game_album])

    if is_saved
      flash[:notice] = "上传成功"
    else
      flash[:error] = "上传的图片不符合要求"
    end

    return redirect_to face_game_albums_path
  end

  def show
    userid = params[:user_id]
    @game_albums = GameAlbum.where("user_id=#{userid}")
  end

end
