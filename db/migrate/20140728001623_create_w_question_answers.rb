class CreateWQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :w_question_answers do |t|
      t.string :result      # =>  3/4 表示 4题答对3题
      t.boolean :is_passed
      t.references :w_user
      t.timestamps
    end
  end
end
