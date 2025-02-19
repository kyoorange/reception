class AddTimeAndReturnedAtToSpaces < ActiveRecord::Migration[7.2]
  def change
    add_column :spaces, :returned_at, :datetime
  end
end
