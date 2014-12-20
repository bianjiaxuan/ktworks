class MultipleMaterialList < ActiveRecord::Base
  validates :name,:preview_img,:content, :presence => true

  belongs_to :multiple_material

  mount_uploader :preview_img, ImageUploader
end
