class CreateContactReplies < ActiveRecord::Migration
  def change
    create_table :contact_replies do |t|
      t.string :title
      t.string :content
      t.references :contact
      t.timestamps
    end
    add_index :contact_replies, :contact_id
  end
end
