class CreateWQuestions < ActiveRecord::Migration
  def change
    create_table :w_questions do |t|
      t.string :title
      t.text :items
      t.string :result
      t.integer :sort, default: 0
      t.boolean :published, default: true
      t.timestamps
    end
  end
end
