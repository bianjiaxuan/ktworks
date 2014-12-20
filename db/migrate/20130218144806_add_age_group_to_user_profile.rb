class AddAgeGroupToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :age_group, :string

    UserProfile.all.each do |profile|
      profile.set_age_group
      profile.save
    end
  end
end
