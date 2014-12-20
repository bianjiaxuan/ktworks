class Weixin::MultipleMaterialsController < AdminController
  inherit_resources

  def destroy
    resource.remove_preview_img!
    resource.destroy
    redirect_to weixin_materials_path, :notice => "删除成功"
  end

  def show
    redirect_to weixin_material_materials_path
  end

  def edit_list
    @resource = MultipleMaterial.find(params[:id])
    @multiple_material_list = MultipleMaterialList.new
  end

  def update_list
    @multiple_material_list = MultipleMaterialList.new params[:multiple_material_list]
    if @multiple_material_list.save
      redirect_to edit_list_weixin_multiple_material_path(params[:multiple_material_list][:multiple_material_id])
    else
      #flash[:alert] = @multiple_material_list.errors.full_messages.join("|")
      @resource = MultipleMaterial.find(params[:id])
      render :action => :edit_list
    end
    # lists = resource.lists || []
    # list = MulitipleMaterialList.new
    # if params[:multiple_material][:preview_img].present?
    #   list.preview_img =
    # end

    # list.
    # lists << params[:multiple_material][:preview_img]
    # resource.update_attributes lists: lists
    # redirect_to edit_list_s_multiple_material_path(params[:id])
  end

  def preview
    render "weixin/materials/preview",:layout => false
  end

end
