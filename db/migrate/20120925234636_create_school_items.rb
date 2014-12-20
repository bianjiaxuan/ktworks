class CreateSchoolItems < ActiveRecord::Migration
  def change
    create_table :school_items do |t|
      t.string :name
      t.string :local
      t.integer :school_local_id

      t.timestamps
    end
  end
end
