class CreateOnlineCourses < ActiveRecord::Migration
  def change
    create_table :online_courses do |t|
      t.string :name
      t.string :cover
      t.text :course_images
      t.text :gif_images
      t.text :common_error
      t.text :prepare
      t.text :sjx
      t.text :video
      t.timestamps
    end
  end
end
