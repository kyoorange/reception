class AddAssociationsToOccupies < ActiveRecord::Migration[7.2]
  def change
    add_reference :occupies, :registrant, null: false, foreign_key: true
    add_reference :occupies, :tag, null: false, foreign_key: true
  end
end
