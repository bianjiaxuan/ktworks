class MultipleMaterial < ActiveRecord::Base
  validates :name,:preview_img,:content, :presence => true

  mount_uploader :preview_img, ImageUploader

  has_many :lists, class_name: MultipleMaterialList, foreign_key: "multiple_material_id", dependent: :destroy
end
