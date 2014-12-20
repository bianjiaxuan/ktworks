# -*- coding: utf-8 -*-
class UserProfile < ActiveRecord::Base
  #attr_accessor :birthday

  # --- 模型关联
  belongs_to :user, touch: true

  before_save :set_age_group
  validates :gender, inclusion: { in: %w(MM GG) }, unless: proc { |u| u.gender.blank? }

  # 头像上传
  has_attached_file :avatar, :styles => { :medium => "180x180>", :middle => "50x50>",  :thumb => "30x30>" }

  validates_attachment :avatar,# :presence => true,
  #:size => { :in => 0..1.megabytes },
  :content_type => { :content_type => ['image/png', 'image/jpg', 'image/gif', 'image/jpeg'] },
  :on => :upload_avatar

  validates_attachment_size :avatar, :less_than => 1.megabyte, :on => :upload_avatar

  validates :birthday,allow_blank: true,
    format: {with: /\A[12]\d{3}-[01]\d{1}-[0123]\d{1}\z/}
  # --- 校验方法
  #validates :user_id, :introduction, :presence => true

  FOOTBALL_AGES=%w{0到半年 半年到一年 1年到2年 2年到3年 3年到5年 5年到10年 10年以上}
  AGEGROUP = ['U8','U10','U12','U14','U16','U18','U20','U22','OVER22']

  def age
    birthday.present? ? (Time.now.year - birthday.year + 1) : 0
  end

  def set_age_group
    self.age_group = case age
    when 0..8
      'U8'
    when 9..10
      'U10'
    when 11..12
      'U12'
    when 13..14
      'U14'
    when 15..16
      'U16'
    when 17..18
      'U18'
    when 19..20
      'U20'
    when 21..22
      'U22'
    else
      'OVER22'
    end
  end

  # @date_check='2013-06-17'
  # $cities = %w{上海 北京 广州 贵阳 成都 杭州 青岛 大连 天津 济南 新加坡}
  # $scopes= %w{}
  # $countries= %w{中国 新加坡}

  # def self.cities?
  #   if Time.new.strftime("%Y-%m-%d %H%M")!= @date_check
  #     $scopes= %w{}
  #     @date_check = Time.new.strftime("%Y-%m-%d %H%M")
  #     Country.where("kind ='city'").each do |c|
  #       $cities.push(c.name) if $cities.index(c.name)==nil
  #     end
  #     Country.where("kind ='country'").each do |c|
  #       $countries.push(c.name) if $countries.index(c.name)==nil
  #     end
  #     User.where("agent=1 ").each do |u|
  #       $scopes.push(u)
  #     end
  #   end
  #   $cities
  # end

end
