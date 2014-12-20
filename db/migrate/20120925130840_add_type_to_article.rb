class AddTypeToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :art_types, :string
  end
end
