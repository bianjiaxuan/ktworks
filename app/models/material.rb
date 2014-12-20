class Material < ActiveRecord::Base
  validates :name,:preview_img,:content, :presence => true

  mount_uploader :preview_img, ImageUploader

  belongs_to :material_category
end
