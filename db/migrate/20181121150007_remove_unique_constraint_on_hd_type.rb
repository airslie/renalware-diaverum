class RemoveUniqueConstraintOnHDType < ActiveRecord::Migration[5.2]
  def change
    reversible do |direction|
      direction.up do
        execute "drop index if exists \"index_renalware_diaverum.hd_type_maps_on_hd_type\""
      end
    end
  end
end
