class InfoUrl < ActiveRecord::Base

  validates :usage, presence: true
  # validates :url, presence: true

  def image_path
    '/images/' + url
  end

end
