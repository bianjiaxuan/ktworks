class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name, null: false
      t.string :preview_img, :comment => "720x400", null: false
      t.boolean :preview_in_content, :default => true
      t.text :summary
      t.text :content
      t.string   :link,                 default: ""
      t.string   :link_type,            default: "content"
      t.timestamps
    end
  end
end
