class AddManifestoToUserProfile < ActiveRecord::Migration
  def change
   	add_column :user_profiles, :manifesto, :text
  end
end
