class AddUrlToGames < ActiveRecord::Migration
  def change
    add_column :games, :url, :string, :default => ''
    execute "ALTER TABLE `games` ADD UNIQUE `unique_url` (`url`)"
  end
end
