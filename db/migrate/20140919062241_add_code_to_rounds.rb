class AddCodeToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :code, :string
    add_index :rounds, :code
  end
end
