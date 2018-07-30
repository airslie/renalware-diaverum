class CreateAccessMapping < ActiveRecord::Migration[5.1]
  def change
    create_table "renalware_diaverum.access_maps" do |t|
      t.string :diaverum_location_id, null: false
      t.string :diaverum_type_id, null: false
      t.string :side
      t.integer :access_type_id, null: false
      t.timestamps null: false
    end

    add_index(
      "renalware_diaverum.access_maps",
      [:diaverum_location_id, :diaverum_type_id ],
      name: "renalware_diaverum_access_maps_idx",
      unique: true
    )
  end
end
