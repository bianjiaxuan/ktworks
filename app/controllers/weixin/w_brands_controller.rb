class Weixin::WBrandsController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_brands_path
  end
end
