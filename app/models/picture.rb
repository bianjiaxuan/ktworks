class Picture < ActiveRecord::Base
  # validates_presence_of :album_id

  belongs_to :album

  default_scope -> { order('id DESC') }
  scope :undetail, -> { where(is_detail: false) }

  has_attached_file :avatar, :styles => { :medium => "800x800>", :middle => "250x250>",  :thumb => "80x80>" }

  validates_attachment :avatar, :presence => true,
  :content_type => { :content_type => ["application/octet-stream"] }

  # validates_attachment_size :avatar, :less_than => 1.megabyte, :on => :upload_avatar

  # validates_attachment_content_type :avatar, :content_type => ["application/octet-stream"]

  def order
    album.pictures.where('id >= ?', self.id).order('id DESC').count
  end

  def next_pic
    album.pictures.where('id < ?', self).order('id DESC').limit(1).first
  end

  def pre_pic
    album.pictures.where('id > ?', self).order('id DESC').limit(1).first
  end

  def to_s
    "picture_#{self.id}"
  end
end
