class RemoveUniqueConstraintOnHDType < ActiveRecord::Migration[5.2]
  def change
    reversible do |direction|
      direction.up do
        # Remove an awkwardly named index that we don't want anyway
        execute(
          "drop index if exists "\
          "\"renalware_diaverum\".\"index_renalware_diaverum.hd_type_maps_on_hd_type\""
        )
      end
    end
  end
end
