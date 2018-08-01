class CreateSchema < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up    { create_schema "renalware_diaverum" }
      direction.down  { drop_schema "renalware_diaverum" }
    end
  end
end
