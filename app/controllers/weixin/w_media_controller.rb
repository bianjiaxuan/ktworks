class Weixin::WMediaController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_media_path
  end
end
