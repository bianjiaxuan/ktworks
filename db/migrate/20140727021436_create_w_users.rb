class CreateWUsers < ActiveRecord::Migration
  def change
    create_table :w_users do |t|
      t.string :wx_id
      t.string :subscribe
      t.string :nickname
      t.string :sex
      t.string :city
      t.string :country
      t.string :province
      t.string :language
      t.string :headimgurl
      t.datetime :subscribe_time

      t.timestamps
    end
  end
end
