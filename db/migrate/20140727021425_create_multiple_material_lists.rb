class CreateMultipleMaterialLists < ActiveRecord::Migration
  def change
    create_table :multiple_material_lists do |t|
      t.string :name, null: false
      t.string :preview_img, :comment => "720x400", null: false
      t.boolean :preview_in_content, :default => true
      t.text :summary
      t.text :content
      t.references :multiple_material
      t.string   :link,                 default: ""
      t.string   :link_type,            default: "content"

      t.timestamps
    end
    add_index :multiple_material_lists, :multiple_material_id
  end
end
