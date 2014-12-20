class Weixin::WServicesController < AdminController
  inherit_resources

  before_filter :find_service

  def index

  end
  def first_gz

  end

  def auto_reply

  end

  def update
    @w_service = WService.first
    @w_service.update_attributes params.require(:w_service).permit!
    if params[:request_url]
      redirect_to params[:request_url],notice: "更新成功"
    else
      redirect_to "/weixin/w_services",notice: "更新成功"
    end
  end

  def get_gz_reply_content
    @show_content = @w_service.gz_reply_type == params[:type].to_i
    render :text => render_to_string(:partial => "weixin/w_services/gz_reply_content")
  end

  def get_auto_reply_content
    @show_content = @w_service.auto_reply_type == params[:type].to_i
    render :text => render_to_string(:partial => "weixin/w_services/auto_reply_content")
  end

  private
  def find_service
    @w_service = WService.first
  end

end
