class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :title
      t.string :content
      t.string :email
      t.string :xingming
      t.timestamps
    end
  end
end
