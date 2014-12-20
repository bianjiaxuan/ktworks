class AddAuthenticationIndex < ActiveRecord::Migration
  def up
    add_index "authentications", ["uid", "provider"], :name => "idx_authentication_uids"
  end

  def down
    remove_index 'authentications', :name => 'idx_authentication_uids'
  end
end
