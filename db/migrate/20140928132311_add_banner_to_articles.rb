class AddBannerToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.has_attached_file :banner
    end
  end

  def self.down
    drop_attached_file :articles, :banner
  end
end
