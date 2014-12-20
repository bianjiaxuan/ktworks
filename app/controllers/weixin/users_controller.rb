class Weixin::UsersController < ApplicationController
  RANK_LIST_HIGHER_SIZE = 4
  RANK_LIST_LOWER_SIZE = 5
  RANK_LIST_SIZE = RANK_LIST_HIGHER_SIZE + RANK_LIST_LOWER_SIZE + 1


  skip_before_filter :verify_authenticity_token
  before_filter :find_wx_user
  layout "weixin"

  def guanzhu
    # 是否激活
    if @w_user.user.present?
      redirect_to "/weixin/users/user_card?wx_id=#{params[:wx_id]}"
    else
      redirect_to "/weixin/users/sign_up?wx_id=#{params[:wx_id]}"

      # 是否答题
      # passed_count = @w_user.answers.where("is_passed = 1").count
      # if passed_count > 0
      #   redirect_to "/weixin/users/question_correct?wx_id=#{params[:wx_id]}"
      # else
      #   clear_wq_session
      #   reset_wq_session
      #   redirect_to "/weixin/users/questions?step=1&wx_id=#{params[:wx_id]}"
      # end
    end
  end

  # 微信问答
  def questions
    step = params[:step].to_i
    questions = WQuestion.where("published = 1")
    @question = questions.order("sort asc")[step-1]
    if request.post?
      update_question(@question,params[:answer])
      if step >= questions.size
        w_question_answer = check_question @w_user
        if w_question_answer.is_passed
          clear_wq_session
          redirect_to "/weixin/users/question_correct?&wx_id=#{params[:wx_id]}"
        else
          reset_wq_session
          redirect_to "/weixin/users/question_error?&wx_id=#{params[:wx_id]}"
        end
      else
        redirect_to "/weixin/users/questions?step=#{step+1}&wx_id=#{params[:wx_id]}"
      end
    end
  end

  def question_error

  end

  def question_correct

  end

  def select_sign_up

  end

  def sign_old_user
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user.present?
        redirect_to "/weixin/users/sign_up_01?olduser_id=#{user.id}&wx_id=#{params[:wx_id]}"
      else
        flash[:alert1] = "用户名或密码不正确"
        render
      end
    end
  end

  def sign_up
    if request.post?
      # 支持手机号直接登陆
      email = params[:email]
      password = params[:password]
      user = User.where("email = ? or phone = ?",email,password).first
      if user.present?
        if user.valid_password?(password)
          redirect_to "/weixin/users/sign_up_auth?olduser_id=#{user.id}&wx_id=#{params[:wx_id]}"
        else
          flash[:alert1] = "密码不正确"
          return
        end
      else
        if password.size < 5 or password.size > 20
          flash[:alert1] = "密码必须5-20位"
          return
        else
          Rails.cache.write "weixin_user_#{@w_user.id}",[email,password]
          redirect_to "/weixin/users/sign_up_auth?olduser_id=&wx_id=#{params[:wx_id]}"
        end
      end
    end
  end

  def sign_up_auth
    if request.post?
      _code = params[:authcode]
      if Rails.cache.read("weixin_authcode_#{@w_user.id}") == _code
        # 手机绑定成功
        user_info = Rails.cache.read("weixin_user_#{@w_user.id}")
        Rails.cache.write "weixin_authcode_#{@w_user.id}",nil
        Rails.cache.write "weixin_user_#{@w_user.id}",nil
        result = User.create_from_weixin(params[:mobile],@w_user,user_info,params[:olduser_id])
        if result.is_a?(Array)
          flash[:alert] = result.first
          return render
        end
        return redirect_to "/weixin/users/user_card?&wx_id=#{params[:wx_id]}"
      else
        flash[:mobile] = params[:mobile]
        # 验证码输入错误
        flash[:alert] = "验证码输入错误"
        return render
      end
    end
  end

  def sign_up_01
    if request.post?
      mobile = params[:mobile]
      _code = create_authcode
      Rails.cache.write "weixin_authcode_#{@w_user.id}",_code
      SMS3.sendto mobile,"KT足球微信注册验证码:#{_code}"
      redirect_to "/weixin/users/sign_up_02?mobile=#{mobile}&wx_id=#{params[:wx_id]}&olduser_id=#{params[:olduser_id]}"
    end
  end

  def sign_up_02
    if request.post?
      _code = params[:authcode]
      if Rails.cache.read("weixin_authcode_#{@w_user.id}") == _code
        # 手机绑定成功
        Rails.cache.write "weixin_authcode_#{@w_user.id}",nil
        result = User.create_from_weixin(params[:mobile],@w_user,params[:olduser_id])
        if result.is_a?(Array)
          flash[:alert] = result.first
          return render
        end
        return redirect_to "/weixin/users/user_card?&wx_id=#{params[:wx_id]}"
      else
        # 验证码输入错误
        flash[:alert] = "验证码输入错误"
        return render
      end
    end
  end

  def get_authcode
    _code = create_authcode
    mobile = params[:mobile]
    Rails.cache.write "weixin_authcode_#{@w_user.id}",_code
    SMS3.sendto mobile,"KT足球微信注册验证码:#{_code}"
    render :js => "alert('验证码已发送至您的手机')"
  end

  def user_card

  end

  def my_scores
    if params[:wx_id].blank?
      return render :text => "参数错误"
    end
    if @w_user.user.blank?
      return redirect_to "/weixin/users/guanzhu?wx_id=#{params[:wx_id]}"
    end
    @user = @w_user.user
    @wins = Round.where(:user_id=>"#{@user.id}",:result => 1).count
    @loses = Round.where(:user_id=>"#{@user.id}",:result=> -1).count
    @total = @wins + @loses
    @scores = scores(@user)
  end

  private

  def update_question question,answer
    hash = get_wq_session
    hash[question] = answer
    Rails.cache.write "wq_"+@w_user.wx_id, hash
  end

  def check_question w_user
    result = get_wq_session
    corrects = 0; errors = 0;
    result.each_pair do |k,v|
      if k.result == v
        corrects += 1
      else
        errors += 1
      end
    end
    w_question_answer = WQuestionAnswer.new w_user: w_user, result: "#{corrects}/#{result.size}", is_passed: errors.zero?
    w_question_answer.save
    w_question_answer
  end

  def find_wx_user
    wx_id = params[:wx_id]
    @w_user = WUser.where(:wx_id => wx_id).first
    if @w_user.blank?
      w_service = WService.first
      if w_service.app_secret.present?
        # 调用前检查token有效期
        check_access_token(w_service)
        token = w_service.access_token
        @w_user = WUser.new(:wx_id => wx_id)
        get_wx_user(wx_id,token,@w_user)
      end
    end
  end

  def clear_wq_session
    hash = get_wq_session
    if hash.present?
      Rails.cache.write "wq_"+@w_user.wx_id, nil
    end
  end

  def get_wq_session
    Rails.cache.read("wq_"+@w_user.wx_id) || {}
  end

  def reset_wq_session
    Rails.cache.write "wq_"+@w_user.wx_id , {}
  end

  def create_authcode
    s = ""
    6.times do
      s += rand(10).to_s
    end
    s
  end

  def scores(user)
    score = user.scores
    higher_scores = User.where("scores > ?", score).order('scores, id').limit(9).reverse
    lower_scores = User.where("scores <= ? and nickname != ?", score, user.nickname).order('scores DESC, id desc').limit(9)

    high_size = [higher_scores.size, RANK_LIST_HIGHER_SIZE].min
    low_size  = [lower_scores.size, RANK_LIST_SIZE - 1 - high_size].min
    high_size = [higher_scores.size, RANK_LIST_SIZE - 1 - low_size].min

    scores = higher_scores[-high_size..-1] + [user] + lower_scores[0..low_size-1]
    scores
  end

end
