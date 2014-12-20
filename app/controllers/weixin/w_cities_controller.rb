class Weixin::WCitiesController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_cities_path
  end
end
