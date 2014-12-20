class AddInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :sex, :string
    add_column :users, :local, :string
  end
end
