class Weixin::MaterialsController < AdminController
  inherit_resources

  def show
    redirect_to weixin_materials_path
  end

  def destroy
    resource.remove_preview_img!
    resource.destroy
    redirect_to s_materials_path, :notice => "删除成功"
  end

end
