class AlbumsController < InheritedResources::Base
  def index
    @albums = Album.order('id DESC').page(params[:page]).per(12)
  end

  def show
    @pictures = Picture.where(album_id: params[:id]).order('id DESC').page(params[:page]).per(12)
    show!
  end
end
