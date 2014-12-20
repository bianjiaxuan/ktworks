class AddThanksPeoPleToNewPlant < ActiveRecord::Migration
  def change
    add_column :new_plants, :thanks_people, :string
  end
end
