class CreateSchoolLocals < ActiveRecord::Migration
  def change
    create_table :school_locals do |t|
      t.string :name

      t.timestamps
    end
  end
end
