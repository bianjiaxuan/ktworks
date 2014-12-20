class AddClubIdToBag < ActiveRecord::Migration
  def change
    add_column :bags, :club_id, :integer,:default => 0

  end
end
