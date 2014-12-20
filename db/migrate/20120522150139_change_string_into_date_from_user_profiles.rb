class ChangeStringIntoDateFromUserProfiles < ActiveRecord::Migration
  def change
  	change_column :user_profiles, :birthday, :date
  end
end
