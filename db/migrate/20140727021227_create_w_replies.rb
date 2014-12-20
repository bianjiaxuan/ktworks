class CreateWReplies < ActiveRecord::Migration
  def change
    create_table :w_replies do |t|
      t.string :keyword, null: false

      t.integer :reply_type, default: "text", comment: "0: text 1: material 2: multiple_material 3: audio_meterial"
      t.text   :reply_content

      t.timestamps
    end

    add_index :w_replies, :reply_type
  end
end
