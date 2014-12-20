# -*- coding: utf-8 -*-
class League < ActiveRecord::Base

  has_one :usera, :class_name => 'User',:primary_key =>'usera_id',:foreign_key=>"id"
  has_one :userb, :class_name => 'User',:primary_key =>'userb_id',:foreign_key=>"id"
  has_many :rounds,-> { where("game_type = 1") },:class_name=>'Round',:primary_key =>'id',:foreign_key => "user_id", :dependent => :destroy

  has_and_belongs_to_many :game_vedios, :join_table => 'game_records',:conditions =>"`game_vedios`.game_type=1 "
  # 头像上传
  has_attached_file :avatar, :default_style => :normal,
    :styles => { :medium => "180x180>", :normal => "50x50>",  :thumb => "30x30>" },
    :url => "/uploadfiles/:class/:attachment/:id/:basename/:style.:extension",
    :path => ":rails_root/public/uploadfiles/:class/:attachment/:id/:basename/:style.:extension"

  validates_attachment :avatar,# :presence => true,
    :content_type => { :content_type => ['image/png', 'image/jpg', 'image/gif', 'image/jpeg'] },
    :on => :upload_avatar

  validates_attachment_size :avatar, :less_than => 1.megabyte, :on => :upload_avatar
  validates_uniqueness_of :name,  :case_sensitive => false
  validate  :name_length_valid?
  validates :name,
    presence: true,
    format: {with: /^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$/, multiline: true}

  LEAGUE_TYPES_STEADY=:STEADY
  LEAGUE_TYPES_TEMP=:TEMP
  #LEAGUE_TYPES_WAIT=:WAIT
  #LEAGUE_TYPES_IGNORE=:IGNORE

  after_save :update_uservipcounts!
  #status:0 ,app create temp
  #status:1 ,steady league  ====>STEADY
  #status:2 ,wait to steady
  #status:3 ,refuse to accept league
  #status:4 ,delete,steady to temp
  def self.create_by_usera_and_userb(user1_id, user2_id,league_type)
    League.create!(usera_id: user1_id,
      userb_id: user2_id,
      name: "#{user1_id}#{user2_id}联盟",
      league_type: "#{league_type}"
    )
  end

  def name_length_valid?
    #"汉字“.bytesize=6
    #"汉".bytesize=3
    if name.bytesize < 5 or name.bytesize > 30
      errors.add(:name, "2到10个汉字或5~20个字母")
    end
  end
  def self.find_by_usera_and_userb usera, userb
    League.find_by_usera_id_and_userb_id(usera,userb)||
      League.find_by_usera_id_and_userb_id(userb,usera)
  end

  def users?
    User.where("id in(#{usera_id},#{userb_id})")
  end

  def rank
    League.where("scores > ?", scores).size + 1
  end

  def joint
    rounds.where('uploaded = ? and game_type = 1', true)
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

  # 累计进球数
  def goal_count
    joint.map(&:goals).sum
  end

  # 累计穿裆数
  def pannas_count
    joint.map(&:pannas).sum
  end

  # 累计KT数
  def kt_count
    joint.where(:panna_ko => true).count
  end

  def update_uservipcounts!
    update_usercount(usera_id)
    update_usercount(userb_id)
  end

  private
  def update_usercount(user_id)
    user = User.find(user_id)
    user.vip_count= user.vip_count.pred if user.is_in_vip_period && user.vip_count > 0
    user.save!
  end
end
