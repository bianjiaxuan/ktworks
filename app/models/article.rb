class Article < ActiveRecord::Base
  scope :apps, where(art_types: 'app_article')
  scope :game_intros, -> { where(art_types: 'app_game_intro') }
  scope :game_routes, -> { where(art_types: 'app_game_routes') }
  scope :news, -> { where(art_types: 'kicktempo_news') }
  scope :new_plant_stroys, -> { where(art_types: "kicktempo_story") }

  # 头像上传
  has_attached_file :banner, :styles => { :slide => "820x460>", :thumb => "300x260#"}

  validates_attachment :banner, # => :presence => true,
  :content_type => { :content_type => ['image/png', 'image/jpg', 'image/gif', 'image/jpeg'] }

  def self.recommend_arts(new_plant)
    new_plant_stroys.where(id: new_plant.recommend_art_ids.split('#'))
  end
end
