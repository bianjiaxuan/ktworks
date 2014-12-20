# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  require 'sms'
  include Sms

  COINS_WIN = 15
  COINS_LOSE = 1
  COINS_DRAW = 5
  has_many :orders
  has_many :rounds, -> { where("game_type = 0") }, dependent: :destroy
  has_many :rounds_2v2, -> { where("game_type = 1 and uploaded = ?",true) }, class_name: Round ,dependent: :destroy
  #has_many :rounds_2v2, -> { where("game_type = 1") }, class_name: Round ,dependent: :destroy
  has_one :selected_sms_user
  has_one :inviter
  has_one :judgeclub,class_name: "Club", primary_key: "judgeclub_id",foreign_key: "id"
  has_many :clubs,class_name: "Club", primary_key: "id",foreign_key: "user_id"
  has_one :profile, :class_name => 'UserProfile'
  belongs_to :invitor, :class_name => 'User', :counter_cache => true
  #has_many   :invitees, :class_name => 'User', :foreign_key => "invitor_id"
  has_many :authentications
  has_and_belongs_to_many :game_vedios, :join_table => 'game_records',:conditions =>"`game_vedios`.game_type=0 "

  has_one :w_user

  has_many :game_applications
  has_many :games, :through => :game_applications

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #:confirmable
  devise :database_authenticatable, :registerable,:confirmable, :encryptable, #,:confirmable,
    :recoverable, :rememberable, :trackable, :omniauthable, omniauth_providers: [:weibo, :renren, :qq_connect]

  attr_accessor :invited_by, :created_by_oauth, :authuser_updating, :login

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :vip_count,:actives_count,:users_count,:invitor_id,:email, :nickname, :password, :password_confirmation, :remember_me,
  #   :phone, :varified_code, :varified, :subscribed, :admin, :grade, :scores, :terms, :invited_by, :sex, :birthday,
  #   :province, :city, :area,:agent,:is_vip,:start_vip_time,:end_vip_time,:is_judge,:judge_day,:judge_end_day,:agent,:agent_day,:agent_end_day,
  #   :judgeclub_id

   #judge

  validates :phone,:uniqueness => {
    :case_sensitive => false, :allow_blank => true
  }

  validates :email, presence: true, :if => Proc.new { |u| u.require_oauth_valid? },:length => { :maximum => 50 },format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,3})\Z/i}
  validates :password, length: { in: 5..20 } , :if => Proc.new { |u| u.password }
  validates :password, presence: true, :confirmation => true,
    :if => Proc.new { |u| u.require_password_valid? }
  # validate  :nickname_length_valid?
  # validates :nickname,
  #   presence: true,
  #   format: {with: /^(?!_)(?!.*?_$)[a-zA-Z0-9_\-\u4e00-\u9fa5]+$/,multiline: true},
  #   exclusion: {in: %w(admin administrator support notification)}

  validates :invited_by, presence: true, :if => Proc.new { |u| u.invited_by }
  validates_uniqueness_of :nickname,  :case_sensitive => false
  validates_uniqueness_of :email,  :case_sensitive => false
  #validates :sex, :city, :birthday, :presence => true, :if => Proc.new { |u| u.new_record? && u.created_by_oauth != 'y' }
  validates :sex, inclusion: { in: %w(MM GG) }, unless: proc { |u| u.sex.blank? }
  validates :birthday,allow_blank: true,
      format: {with: /\A[12]\d{3}-[01]\d{1}-[0123]\d{1}\z/, multiline: true}
  validates :phone,
      allow_blank: true,
      uniqueness: true,
      format: {with: /^[0-9]{11}$/, multiline: true}

  validates :varified_code,
      allow_blank: true,
      format: {with: /^[0-9]{4}$/, multiline: true}

  validates :terms, acceptance: true

  before_create :create_referral
  #before_save :ensure_authentication_token
  after_create :create_profile

  SOURCE_APP=1
  SOURCE_BACKGROUND=2

  class << self
    def authenticate email, password
      # 支持手机号直接登陆
      user = where("email = ? or phone = ?",email,email).first
      # find_by_email(email)
      return nil if user.nil? or !user.valid_password?(password)
      user
    end

    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

    def create_from_weixin mobile,w_user,_user_info=nil,olduser_id=nil
      # 旧用户的绑定
      if olduser_id.present?
        user = User.find(olduser_id)
        user.phone = mobile
        user.varified = true
        #user.nickname = w_user.nickname
        user.has_subscribed_sms = true
        unless user.save
          return [user.errors.full_messages.join("|")]
        end
      else
        user = User.where(:phone => mobile).first
        if user.blank?
          puts mobile
          puts w_user.nickname

          if _user_info.present? && _user_info.is_a?(Array) && _user_info.size == 2
            email = _user_info.first
            password = _user_info.last
          else
            email = mobile+"@kicktempo.cn"
            password = mobile
          end

          user = User.new :email => email,
                      :password => password,
                      :password_confirmation => password,
                      :phone => mobile,
                      :nickname => w_user.nickname,
                      :varified => true,
                      :has_subscribed_sms => true,
                      :vip_count => 3
          unless user.save
            user.nickname = w_user.nickname + Time.now.to_i.to_s
            unless user.save
              return [user.errors.full_messages.join("|")]
            end
          end
        end
      end
      w_user.user = user
      w_user.save

      # 更新微信信息
      user.sync_w_user_info(true)
    end
  end

  def sync_w_user_info sync_avatar=false
    w_user = self.w_user
    if w_user.present?
      # 保存昵称
      self.nickname = w_user.nickname
      self.save

      # 保存头像 & 其他个人信息
      profile = self.profile
      if sync_avatar && w_user.headimgurl.present?
        profile.avatar = w_user.headimgurl
      end
      profile.province = w_user.province
      profile.city = w_user.city
      profile.gender = w_user.sex.to_i == 2 ? "MM" : "GG"
      profile.country = w_user.country
      profile.save
    end
  end

  def remain_judge_day
    if is_judge && judge_day
      start = judge_day.strftime("%Y-%m-%d")
      today = Time.now.strftime("%Y-%m-%d")
      return 365-(DateTime.parse(today)-DateTime.parse(start)).to_i
    end
  end

  def remain_agent_day
    if agent && agent_day
      start = agent_day.strftime("%Y-%m-%d")
      today = Time.now.strftime("%Y-%m-%d")
      return 365-(DateTime.parse(today)-DateTime.parse(start)).to_i
    end
  end

  def nickname_length_valid?
    #"汉字“.bytesize=6
    #"汉".bytesize=3
    if nickname.bytesize < 5 or nickname.bytesize > 30
      errors.add(:nickname, "2到10个汉字或5~20个字母")
    end
  end

  def require_oauth_valid?
    return false if created_by_oauth == 'y'
    return false if created_by_oauth == 'mobile'
    new_record?
  end

  def require_password_valid?
    return false if created_by_oauth == 'y'
    return false if created_by_oauth == 'mobile'
    password.present?
  end

  def confirmation_required?
    #cancel confirmation
    return false
    return false if created_by_oauth == 'y'
    return false if created_by_oauth == 'mobile'
    !confirmed?
  end

  def qrcode_img
    #"http://chart.googleapis.com/chart?chs=180x180&cht=qr&chl=#{id}"
    "http://qr.liantu.com/api.php?&bg=ffffff&fg=000000&text=#{id}"
  end

  def invite_qrcode_img url
    "#{SERVICES['qrcode']['googleapis']}&chs=200x200&chl=#{url}"
  end

  # check whether it's empty or not, set to unvarified, generate code, then send it by lib/sms.rb
  def send_code
    return :blank_phone if self.phone.blank?
    self.generate_code
    SMS3.sendto self.phone, "您的KickTempo手机验证码为：#{self.varified_code}。"
  end

  def varify submit_code
    self.varified ||= (self.code == submit_code)
  end

  def terms
    @terms
  end

  def terms= bool
    @terms = bool
  end

  def leagues
    League.where("usera_id = ? or userb_id = ?",self.id,self.id)
  end

  def vip_login_check
     #return true if vip_count > 0 || end_vip_time.present? && Time.new < end_vip_time
     if end_vip_time.present? && Time.new < end_vip_time
      return true
    elsif vip_count > 0
      return true
    else
      return false
     #return vip_count > 0
     #return false
   end
  end

  def get_inviter
      ivt= agent ? (Inviter.where(" user_id in(select user_id from clubs where agent_id=#{id})")
      .select("sum(invitees_count) as invitees_count,sum(lives_count) as lives_count")
      .first) : inviter
      ivt ? ivt : Inviter.new
  end

  def rank
    User.where("scores > ?", scores).size + 1
  end

  # Replace the original find with case-insensitive.
  def self.find_by_nickname nickname
    self.find(:first, conditions: [ "nickname = ?", nickname.downcase ])
  end

  def joint
    rounds.where('uploaded = ? and game_type = 0', true)
  end

  def showtimes
    joint.size
  end

  def wins
    joint.where("result = 1").size
  end

  def draws
    joint.where("result = 0").size
  end

  def loses
    joint.where("result = -1").size
  end

  def wins_2v2
    rounds_2v2.where("result = 1")
  end

  def draws_2v2
    rounds_2v2.where("result = 0")
  end

  def loses_2v2
    rounds_2v2.where("result = -1")
  end

  # 累计进球数
  def goal_count
    self.rounds.map(&:goals).sum
  end

  # 累计穿裆数
  def pannas_count
    self.rounds.map(&:pannas).sum
  end

  # 累计KT数
  def kt_count
    self.rounds.where(:panna_ko => true).count
  end

  # 累计2v2进球数
  def kt_count_2v2
    rounds_2v2.where(:panna_ko => true)
  end

  # 2v2累计进球数
  def goal_count_2v2
    rounds_2v2.map(&:goals).sum
  end

  # 2v2累计穿裆数
  def pannas_count_2v2
    rounds_2v2.map(&:pannas).sum
  end

  # 判断是否是有效会员
  def is_available_vip
    return true if  is_vip && (vip_count>0 or Time.now.strftime('%Y-%m-%d')< end_vip_time.to_s)
    return false
  end

  def is_in_vip_period
    return true if is_vip && (vip_count>0 or Time.now.strftime('%Y-%m-%d')< end_vip_time.to_s )
    return false
  end

  def vip_desc
     return  "#{vip_count} 次"  if is_in_vip_period && vip_count>0
     return  "From #{start_vip_time} <p>To #{end_vip_time}</p>" if is_in_vip_period && vip_count <= 0
  end

  def share_status
    "我参加了#{showtimes}次，KICK TEMPO 的新式足球运动，获得了胜：#{wins}，平：#{draws}，负：#{loses}的战绩, 这是一宗无限、自由、技巧、音乐和快乐的足球玩法。 http://kicktempo.cn/user/#{id}"
  end

  def score_alerting?
    flag = false
    gv = GameVedio.find_by_sql("select count(*) as count from game_vedios v where v.id in
      (select game_vedio_id from game_records where user_id=#{id} and score=0) and
       v.created_at > date_sub(now(),interval 7 day)").first
    flag = (gv.count > 0)
    flag
  end

  def avatar
    if self.profile.present?
      if self.profile.avatar.file?
        self.profile.avatar.url
      else
        "/assets/default_avatar.jpg"
      end
    else
      "/assets/default_avatar.jpg"
    end
  end

  def share_info provider
    begin
      if auth = authentications.find_by_provider(provider)
        case auth.provider
        when 'weibo'
          RestClient.post(
            'https://api.weibo.com/2/statuses/update.json',
            {'access_token' => auth.access_token, 'status' => share_status})

          return { :success => true, :message => '分享成功。' }
        when 'renren'
          res = RestClient.post( 'https://api.renren.com/restserver.do',
            {
              'method' => 'feed.publishFeed',
              'access_token' => auth.access_token,
              'message' => share_status,
              'url' => "http://kicktempo.cn/user/#{id}",
              'name' => '我的 KICK TEMPO 战绩',
              'description' => share_status,
              'format' => 'json'
            })

          return { :success => true, :message => '分享成功。' }
        when 'qq_connect'
          res = RestClient.post( 'https://open.t.qq.com/api/t/add',
            {
              'access_token' => auth.access_token,
              'oauth_consumer_key' => '100372235',
              'openid' => auth.uid,
              'oauth_version' => '2.a',
              'content' => share_status,
              'format' => 'json'
            })

          return { :success => true, :message => '分享成功。' }
        end
      else
        return { :success => false, :message => '分享失败，没有绑定该平台。' }
      end
    rescue
      return { :success => false, :message => '网络错误，分享失败。' }
    end
  end

  def build_authentication_by_params(uid, provider, token)
    auth = authentications.new(:uid => uid, :provider => provider, :access_token => token)
    auth.save
  end

  class << self
    def new_with_session(params, session)
      super.tap do |user|
        if auth_hash = session[:omniauth]
          user.nickname = auth_hash['info']['nickname']
          user.authentications.build(:uid => auth_hash.uid, provider: auth_hash.provider, access_token: auth_hash.credentials.token)
        end
      end
    end

    def new_with_omniauth(auth_hash)
      user = User.new({nickname: auth_hash['info']['nickname'] || auth_hash['info']['name'] || '平台用户', created_by_oauth: 'y' }, without_protection: true)
      user.authentications.build(:uid => auth_hash.uid, provider: auth_hash.provider, access_token: auth_hash.credentials.token)
      user
    end

    def confirm_by_token(confirmation_token)
      original_token     = confirmation_token
      # confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)

      confirmable = find_or_initialize_with_error_by(:confirmation_token, original_token)#confirmation_token)
      confirmable.confirm! if confirmable.persisted?
      confirmable.confirmation_token = original_token
      confirmable
    end

  end

  def create_profile
    profile = UserProfile.create(:province => province, :city => city, :area => area, :gender => sex, :birthday => birthday )
    profile.user = self
    profile.avatar = "http://kicktempo.cn/assets/default_avatar.jpg"
    profile.save
  end

  private
  def create_referral
    if self.invited_by && claimed_inviter = User.find_by_nickname(self.invited_by)
      self.invitor = claimed_inviter
    end
    #self.vip_count = 10
  end


  def after_confirmation
    self.vip_count = 3
    self.save
  end
end
