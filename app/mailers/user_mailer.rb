class UserMailer < ActionMailer::Base
  default from: "notification@tempot.com"

  def report_exception(req, exception = nil)
    @req = req
    @exception = exception

    url = @req.url

    err = KtError.new
    err.name = @exception.class
    err.url = url
    err.message = @exception.message
    err.backtrace = @exception.backtrace.join("\r\n")

    if url.include?("/api")
      err.klass = 1
    elsif url.include?("/weixin/users")
      err.klass = 4
    elsif url.include?("/weixin/pages")
      err.klass = 3
    elsif url.include?("/weixin")
      err.klass = 5
    elsif url.include?("/admin")
      err.klass = 2
    else
      err.klass = 0
    end
    err.save

    mail to: '177365340@qq.com', subject: '[KT足球] 500错误报告 ' << req.url.to_s
  end
end
