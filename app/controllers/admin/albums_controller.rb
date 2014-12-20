# -*- coding: utf-8 -*-
class Admin::AlbumsController < AdminController
  inherit_resources
  def index
    @albums = Album.order('id DESC').page(params[:page]).per(20)
  end

  def create
    create! do |success, fail|
      success.html {
        redirect_to admin_albums_url
      }
    end
  end

  def show
    @album = Album.find(params[:id])
    @pictures = Picture.where(album_id: params[:id]).order('id DESC').page(params[:page]).per(15)
    if params[:cover] && @album.pictures.where(id: params[:cover])
      @album.update_attribute(:cover_id, params[:cover])
    end
    show!
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to admin_albums_url
      }
    end
  end
end
