class CreateWServices < ActiveRecord::Migration
  def change
    create_table :w_services do |t|
      t.string :app_id
      t.string :app_secret

      t.string :access_token
      t.datetime :access_token_expire_time

      t.integer :gz_reply_type, default: "text", comment: "0: text 1: material 2: multiple_material 3: audio_meterial"
      t.text   :gz_reply_content

      t.integer :auto_reply_type, default: "text", comment: "0: text 1: material 2: multiple_material 3: audio_meterial"
      t.text   :auto_reply_content

      t.timestamps
    end

    add_index :w_services, :gz_reply_type
    add_index :w_services, :auto_reply_type

    WService.create if WService.count.zero?
  end
end
