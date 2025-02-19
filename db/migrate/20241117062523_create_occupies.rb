class CreateOccupies < ActiveRecord::Migration[7.2]
  def change
    create_table :occupies do |t|
      t.integer :time_length
      t.datetime :returned_at

      t.timestamps
    end
  end
end
