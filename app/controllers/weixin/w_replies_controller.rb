class Weixin::WRepliesController < AdminController
  inherit_resources

  def show
    redirect_to weixin_w_replies_path
  end

  def get_reply_content
    if params[:id].present?
      @reply = WReply.find(params[:id])
    end
    render :text => render_to_string(:partial => "weixin/w_replies/reply_content")
  end
end
