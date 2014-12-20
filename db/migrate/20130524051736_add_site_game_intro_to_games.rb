class AddSiteGameIntroToGames < ActiveRecord::Migration
  def change
    add_column :games, :site_introduction,:text

    add_column :games, :site_traffic,:text

    add_column :games, :site_arround, :text

  end
end
