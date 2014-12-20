class CreateBatchUsers < ActiveRecord::Migration
  def change
    create_table :batch_users do |t|
      t.string :email
      t.string :password
      t.integer :seq
      t.boolean :status, :default=>false

      t.timestamps
    end
  end
end
