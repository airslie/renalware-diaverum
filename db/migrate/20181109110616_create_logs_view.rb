class CreateLogsView < ActiveRecord::Migration[5.2]
  def change
    reversible do |direction|
      direction.up { connection.execute("SET SEARCH_PATH=renalware_diaverum,renalware,public;") }
      direction.down { connection.execute("SET SEARCH_PATH=renalware_diaverum,renalware,public;") }
    end
    create_view :logs
  end
end
