class CreateUnitCodes < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up { create_schema "renalware_diaverum" }
      direction.down { drop_schema "renalware_diaverum" }
    end

    create_table "renalware_diaverum.dialysis_units" do |t|
      t.references(
        :hospital_unit,
        foreign_key: { to_table: :hospital_units },
        index: true,
        null: false
      )
      t.timestamps null: false
    end
  end
end
