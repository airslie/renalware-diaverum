class CreateHDTypeMaps < ActiveRecord::Migration[5.2]
  def change
    create_table "renalware_diaverum.hd_type_maps" do |t|
      t.string :diaverum_type_id, null: false, index: { unique: true }
      t.string :hd_type, null: false, index: { unique: true }
      t.timestamps null: false
    end
  end
end
