class AddIsTitleToWMedia < ActiveRecord::Migration
  def change
    add_column :w_media,:is_title, :boolean, default: false
  end
end
