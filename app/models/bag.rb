class Bag < ActiveRecord::Base
  validates_uniqueness_of :code,  :case_sensitive => false
  belongs_to  :club

  has_many :binding_users, class_name: User, :foreign_key => :binding_code, :primary_key => "code"

  has_many :rounds

  def qrcode_img
      "http://chart.googleapis.com/chart?chs=180x180&cht=qr&chl=KTBAG=#{code}|#{name}|#{url}"
  end

  def games
    Game.where(:code => self.code)
  end
end
