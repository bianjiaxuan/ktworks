class WBrand < ActiveRecord::Base
  validates :name, :presence => true

  mount_uploader :logo, ImageUploader
end
