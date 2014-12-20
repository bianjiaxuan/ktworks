class CreateAudioMaterials < ActiveRecord::Migration
  def change
    create_table :audio_materials do |t|
      t.string :name
      t.string :media_id
      t.datetime :exipire_time
      t.timestamps
    end
  end
end
