class AddMoreInfoToGame < ActiveRecord::Migration
  def change
    add_column :games, :avatar_file_name , :string   
    add_column :games, :avatar_content_type, :string   
    add_column :games, :avatar_file_size, :integer  
    add_column :games, :avatar_updated_at, :datetime 

    add_column :games, :country, :string
    add_column :games, :introduction, :text
    add_column :games, :traffic_intro, :text
    add_column :games, :arround_intro, :text
  end
end
