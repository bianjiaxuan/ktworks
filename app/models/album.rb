class Album < ActiveRecord::Base
  has_many :pictures, :dependent => :destroy
  belongs_to :cover, :class_name => Picture

  validates :cover_id,:presence => true

  def cover_url(type)
    cover && cover.avatar.url(type)
  end
end
