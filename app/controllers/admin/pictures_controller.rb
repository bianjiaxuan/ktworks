# -*- coding: utf-8 -*-
class Admin::PicturesController < AdminController
  inherit_resources
  def index
    @pictures = Picture.order('id DESC').page(params[:page]).per(20)
  end

  def create
    create! do |success, fail|
      success.html {
        redirect_to edit_admin_picture_url(@picture)
      }
      fail.html {
        render :new
      }
    end
  end

  def update
    update! do |success, fail|
      success.html {
        redirect_to edit_admin_picture_url(@picture)
      }
    end
  end

  def destroy
    destroy! do |success, fail|
      success.html {
        redirect_to admin_album_url(@picture.album)
      }
    end
  end

  def uploads
    @album = Album.find(params[:album])
  end

  def multi_edit
    load_album
    @undetail_pictures = @album.pictures.undetail
    @pids = @undetail_pictures.collect(&:id).join("#")
  end

  def multi_update
    load_album
    params[:album] && params[:album].each do |picture_key, update_value|
      if picture = Picture.where(id: picture_key.split('_').last).first
        picture.update_attributes(update_value.merge({ is_detail: true }))
      end
    end
    redirect_to admin_album_url(@album)
  end

  private
    def load_album
      @album = Album.find(params[:album_id])
    end

end
