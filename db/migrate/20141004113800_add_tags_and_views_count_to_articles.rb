class AddTagsAndViewsCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :views_count, :integer, default: 0
    add_column :articles, :tags, :string, default: ""
    add_column :articles, :from, :string
  end
end
