class AddStatusToOccupiesWithDefault < ActiveRecord::Migration[7.2]
  def change
    add_column :occupies, :status, :string, default: "available"
  end
end
