class WQuestion < ActiveRecord::Base
  validates :title, presence: true

  serialize :items
end
