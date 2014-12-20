require 'hashie'

# encoding: utf-8
module SmsCubit
  require "savon"

  def self.transmit(content, mobiles)
    client = Savon.client(wsdl: "http://www.jianzhou.sh.cn/JianzhouSMSWSServer/services/BusinessService?wsdl")
    _content = CGI.escape("#{content}【建周科技】")
    message = { account: 'cjz403',
                password: '962008',
                destmobile: mobiles,
                msgText: _content }
    response = client.call(:send_message, message: message)
    return response
    return response.body[:send_message_response][:send_message_result]
  end
end


SMSConfig = Hashie::Mash.new(
  username: 'tempot',
  password: 'f19bdacb65d6efa540948b2811351895',
)

# 云信使
module SMS2
  module_function
  def sendto mobile,content
    RestClient.get "http://api.sms.cn/mt/?uid=tempot&pwd=e21095d977978d4d648be8be887c6cd4&mobile=#{mobile}&content=#{CGI.escape(content)}&encode=utf8"
  end
end

# 联动优势 & 国际短信整合
module SMS3
  module_function
  def sendto mobile,content
    if mobile[0,2] == "09"
      content = Ropencc.conv('simp_to_trad',content).encode("big5")
      RestClient.post "http://imsp.emome.net:8008/imsp/sms/servlet/SubmitSM",account: "14525",password: "14525",to_addr: mobile,msg: content
    else
      # sn = "SDK-BBX-010-21067"
      # pwd = "d-5ef7-["
      # pwd = Digest::MD5.hexdigest(sn+pwd).upcase
      content = CGI.escape("#{content}【KT足球】".encode("gb2312"))
      RestClient.get "http://sdk2.zucp.net:8060/webservice.asmx/mt?sn=SDK-BBX-010-21067&pwd=7EBA8664C176785F93233A8755F46275&mobile=#{mobile}&content=#{content}&ext=&stime=&rrid="
    end
  end
end

# 国际短信
module SMS4
  module_function
  def sendto mobile,content
    content = CGI.escape("#{content}【KT足球】".encode("gb2312"))
    # sn = "SDK-BBX-010-21067"
    # pwd = "d-5ef7-["
    # pwd = Digest::MD5.hexdigest(sn+pwd).upcase
    RestClient.post "http://imsp.emome.net:8008/imsp/sms/servlet/SubmitSM",account: "14525",password: "14525",to_addr: "0911275930",msg: content
  end
end








