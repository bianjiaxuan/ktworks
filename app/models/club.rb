class Club < ActiveRecord::Base
  has_one :agency, class_name: "User", primary_key: "agent_id",foreign_key: "id"
  has_one :manager,class_name: "User", primary_key: "user_id",foreign_key: "id"

  has_one :inviter,class_name: "Inviter", primary_key: "user_id",foreign_key: "user_id"
  has_many :games
  has_many :bags
  validates :name, presence: true
  validates :agent_id, presence: true
  validates :user_id, presence: true

  mount_uploader :avatar, ImageUploader
  mount_uploader :banner, ImageUploader

  def self.managers
  	 User.where("agent=1 or is_judge=1").order("city,id")
  end

  def members
    self.bags.map(&:binding_users).flatten.uniq
  end
end
