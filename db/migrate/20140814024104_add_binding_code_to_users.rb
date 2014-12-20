class AddBindingCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :binding_code, :string, default: ""
  end
end
