class AddActivesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :actives_count, :integer

  end
end
