class Newadmin::AlbumsController < NewadminController
  skip_before_filter :verify_authenticity_token, only: [:upload]

  inherit_resources
  def show
    redirect_to action: "index"
  end

  def create
    picture = Picture.new
    picture.avatar = params[:album][:cover]
    if picture.save
      Album.create :name => params[:album][:name],:cover => picture
      redirect_to action: "index"
    else
      flash[:alert] = picture.errors.full_messages.join(",")
      redirect_to action: "new"
    end
  end

  def update
    album = Album.find(params[:id])
    album.name = params[:album][:name]
    if params[:album][:cover]
      picture = Picture.new
      picture.avatar = params[:album][:cover]
      picture.save
      album.cover = picture
    end
    album.save
    redirect_to action: "index"
  end

  def upload
    if request.post?
      sharing_image = Picture.new(avatar: params[:Filedata],album_id: params[:id].to_i)
      if sharing_image.save
        render json: sharing_image.avatar(:middle)
      else
        return render :json => sharing_image.errors.messages.to_s
      end
    end
  end
end
