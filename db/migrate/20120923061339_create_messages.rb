class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :name
      t.text :content
      t.string :email

      t.timestamps
    end
  end
end
