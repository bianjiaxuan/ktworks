class Weixin::WeixinApiController < ApplicationController
  require 'digest'
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def callback_get
    if check_signature
      render :text => params[:echostr]
    else
      render :text => ""
    end
  end

  def callback_post
    @service = check_signature
    if @service.present?
      xml = params[:xml]
      @to_username = xml[:ToUserName]
      @from_username = xml[:FromUserName]
      @create_tiem = xml[:CreateTime]
      @content = xml[:Content]
      @msg_id = xml[:MsgId]
      @w_user = find_wx_user(@from_username,@service,xml[:MsgType]=="subscribe")
      case xml[:MsgType]
      when 'text'
        @reply = WReply.where(:keyword => @content).first
        if @reply.present?
          return render "keyword_#{@reply.reply_type}", :formats => :xml
        else
          return render "auto_#{@service.auto_reply_type}", :formats => :xml
        end
      when 'image'
      when 'location'
      when 'link'
      when 'event'
        case xml["Event"]
        when "LOCATION"

        when "unsubscribe"

        when "subscribe"
          return render "gz_#{@service.gz_reply_type}", :formats => :xml
        when "CLICK"
          @url = xml["EventKey"]
          case @url
          when "mykt"
            return render "mykt", :formats => :xml
          when "kick"
            return render "kick", :formats => :xml
          else
            return render "click", :formats => :xml
          end
        else

        end
        return render :text => ""
      when 'voice'
      when 'video'
      else
      end
    else
      render :text => ""
    end
  end

  private
  def check_signature
    signature = params[:signature]
    timestamp = params[:timestamp]
    nonce = params[:nonce]
    service = WService.first
    if service
      token = service.wx_token
      str = [token,timestamp,nonce].sort.join
      if Digest::SHA1.hexdigest(str) == signature
        return service
      else
        return false
      end
    else
      return false
    end
  end

  def find_wx_user(wx_id,w_service,sync_avatar=false)
    w_user = WUser.where(:wx_id => wx_id).first
    if w_user.blank?
      w_user = WUser.new(:wx_id => wx_id)
    end
    if w_service.app_secret.present?
      # 调用前检查token有效期
      check_access_token(w_service)
      token = w_service.access_token
      get_wx_user(wx_id,token,w_user,sync_avatar)
    end
    # if w_user.nickname.blank?
    #   check_access_token(w_service)
    #   token = w_service.access_token
    #   get_wx_user(wx_id,token,w_user)
    # end
    w_user
  end

end
