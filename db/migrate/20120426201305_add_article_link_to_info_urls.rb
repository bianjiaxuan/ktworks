class AddArticleLinkToInfoUrls < ActiveRecord::Migration
  def change
    add_column :info_urls, :article_link, :string
  end
end
