class DropSpacesTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :spaces
  end
  def change
  end
  def down
  create_table :spaces do |t|
    t.string :tag_id
    t.datetime :time
    t.integer :time_length
    t.datetime :returned_at

    t.timestamps
    end
  end
end
