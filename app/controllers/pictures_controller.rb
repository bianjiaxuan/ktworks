class PicturesController < InheritedResources::Base

  def save_uploads
    if Album.find(params[:album]).pictures.create(:avatar => params[:picture], :is_detail => false)
      render json: { success: true }
    else
      render json: { success: false }, status: 302
    end
  end

end
