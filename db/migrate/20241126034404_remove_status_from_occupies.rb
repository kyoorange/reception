class RemoveStatusFromOccupies < ActiveRecord::Migration[7.2]
  def change
    remove_column :occupies, :status, :string
  end
end
