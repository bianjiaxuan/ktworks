class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :gender
      t.string :birthday
      t.string :province
      t.string :city
      t.string :area
      t.string :football_age
      t.text :introduction

      t.timestamps
    end
  end
end
