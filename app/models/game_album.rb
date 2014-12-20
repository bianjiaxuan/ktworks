class GameAlbum < ActiveRecord::Base
  
  belongs_to :game

  has_attached_file :face,
    :default_style => :s120,
    :styles => {
    :s800 => "800X800",
    :s500 => "500X500",
    :normal => "180x180#",
    :s120 => "120x120#",
    :s48 => "48x48#",
    :s32 => "32x32#",
    :s16 => "16x16#"
  },
    :url => "/uploadfiles/:class/:attachment/:id/:basename/:style.:extension",
    :path => ":rails_root/public/uploadfiles/:class/:attachment/:id/:basename/:style.:extension"
    
  validates_attachment_content_type :face, :presence => true,:content_type => { :content_type => ['image/png', 'image/jpg', 'image/gif', 'image/jpeg'] },
  :on => :upload_face

end
