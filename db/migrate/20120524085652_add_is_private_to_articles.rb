class AddIsPrivateToArticles < ActiveRecord::Migration
  def change
  	add_column :articles, :is_private, :boolean, :default => false
  end
end
