class AddStatustoOccupies < ActiveRecord::Migration[7.2]
  def change
    add_column :occupies, :status, :string
  end
end
