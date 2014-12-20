class WService < ActiveRecord::Base
  serialize :gz_reply_content
  serialize :auto_reply_content

  enum_attr :gz_reply_type, :in => [
    ['text',  0, '文本'],
    ['material',  1, '单图文'],
    ['multiple_material',2, '多图文'],
    ['audio_meterial',3, '音频']
  ]

  enum_attr :auto_reply_type, :in => [
    ['text',  0, '文本'],
    ['material',  1, '单图文'],
    ['multiple_material',2, '多图文'],
    ['audio_meterial',3, '音频']  ]

  def wx_url
    "http://ktfootball.com/wx_callback"
  end

  def wx_token
    Digest::MD5.new.hexdigest("ktfootball")
  end

  def update_access_token
    r = JSON.parse(RestClient.get "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{self.app_id}&secret=#{self.app_secret}")
    self.update_attributes :access_token => r["access_token"], :access_token_expire_time => Time.now + r["expires_in"].to_i.seconds
  end
end
