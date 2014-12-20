class AddAvatarToLeague < ActiveRecord::Migration   
  def self.up
    change_table :leagues do |t|
      t.has_attached_file :avatar
    end
  end

  def self.down
    drop_attached_file :leagues, :avatar
  end
end
