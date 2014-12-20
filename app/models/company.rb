class Company < ActiveRecord::Base
  has_many :school_items
  validates :name, presence: true
  mount_uploader :logo, ImageUploader

  def image_path
    '/images/' + url
  end
end
