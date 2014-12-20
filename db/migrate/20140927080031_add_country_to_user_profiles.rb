class AddCountryToUserProfiles < ActiveRecord::Migration
  def change
    add_column :user_profiles,:country, :string
  end
end
