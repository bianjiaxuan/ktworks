class CreateOneNewPlantRecord < ActiveRecord::Migration
  def up
    NewPlant.create!(support_counter: 0, indentify: "kicktempo_2026_info")
  end

  def down
  end
end
