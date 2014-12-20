class AddYoukuInfoToNewPlant < ActiveRecord::Migration
  def change
    add_column :new_plants, :youku_info, :text
    add_column :new_plants, :youku_username, :string
    add_column :new_plants, :youku_token, :string
    add_column :new_plants, :youku_refresh_token, :string
  end
end
