class AddSummaryToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :summary, :string,:default=>''
    add_column :articles, :avatar,  :string,:default=>'admin_logo.png'
  end
end
