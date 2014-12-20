class AddBannerToClubs < ActiveRecord::Migration
  def change
    add_column :clubs,:avatar, :string
    add_column :clubs,:banner, :string
  end
end
