class Contact < ActiveRecord::Base
  has_many :contact_replies

  validates :title,:content,:email,:xingming, :presence => true
end
