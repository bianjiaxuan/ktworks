class Coach < ActiveRecord::Base
  belongs_to :user

  validates :name, :presence => true

  has_attached_file :avatar, :styles => { :medium => "180x180>", :middle => "50x50>",  :thumb => "30x30>" }
  validates_attachment :avatar,:content_type => { :content_type => ['image/png', 'image/jpg', 'image/gif', 'image/jpeg'] }
  validates_attachment_size :avatar, :less_than => 1.megabyte

end
