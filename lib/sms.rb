module Sms
  require Rails.root.join('config/kicktempo.rb')

  # Range 1000~9999
  def generate_code
    self.varified = false
    self.varified_code = rand(9000)+1000
    self.save
  end

  def sendto phones, content
    phones.join!(',') if phones.respond_to? :join!

    url = "http://notice.zuitu.com/sms?user=#{SMSConfig.username}&pass=#{SMSConfig.password}&phones=#{phones}&content='#{content}'"
    Rails.logger.info "SMS::send Sending to #{phones} about #{content}. url: #{url}"

    res = `curl '#{url}'`

    if res != '+OK'
      Rails.logger.error "SMS::send Failed to #{phones} about #{content} with response '#{res}'."
    else
      Rails.logger.info "SMS::send Successfully sent."
    end

    return (res == '+OK')
  end
end
