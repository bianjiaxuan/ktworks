class ContactReply < ActiveRecord::Base
  belongs_to :contact
  validates :content, :presence => true
end
