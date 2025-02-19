class ChangeStatusTypeToOccupies < ActiveRecord::Migration[7.2]
  def change
    change_column :occupies, :status, :integer, default: 0
  end
end
