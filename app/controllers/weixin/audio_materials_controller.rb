class Weixin::AudioMaterialsController < AdminController
  inherit_resources

  def create
    media = params[:audio_material][:url]
    # 调用前检查token有效期
    check_access_token

    token = WService.first.access_token
    r = JSON.parse(RestClient.post "http://file.api.weixin.qq.com/cgi-bin/media/upload?access_token=#{token}&type=voice",:media => media)
    error = r["errcode"]
    if error.present?
      return redirect_to weixin_audio_materials_path,:alert => "微信接口返回错误: " + error
    elsif r["media_id"].present?
      AudioMaterial.create :user_id  => params[:audio_material][:user_id],
                           :media_id => r["media_id"],
                           :name     => params[:audio_material][:url].original_filename
      return redirect_to weixin_audio_materials_path, :notice => "上传成功"
    else
      return redirect_to weixin_audio_materials_path,:alert => "未知接口错误"
    end
  end

  def destroy
    resource.remove_url!
    resource.destroy
    redirect_to weixin_audio_materials_path, :notice => "删除成功"
  end

  def show
    redirect_to weixin_audio_materials_path
  end
end
