class CreateDiaverumTransmissionLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :"renalware_diaverum.transmission_logs" do |t|
      t.string :direction, null: false, index: true
      t.string :format, null: false, index: true
      t.references(
        :dialysis_unit,
        foreign_key: { to_table: :"renalware_diaverum.dialysis_units" },
        index: true
      )
      t.references :patient, foreign_key: true, index: true, null: false
      t.text :payload
      t.text :error
      t.string :filepath
      t.datetime :transmitted_at, index: true
      t.timestamps null: false
    end
  end
end
