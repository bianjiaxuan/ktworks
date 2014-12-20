class OnlineCourse < ActiveRecord::Base
  validates :name, presence: true
  mount_uploader :cover, ImageUploader
end
