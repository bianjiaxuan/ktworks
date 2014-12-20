class AddRecommendArtIdsToArticle < ActiveRecord::Migration
  def change
    add_column :new_plants, :recommend_art_ids, :string
  end
end
