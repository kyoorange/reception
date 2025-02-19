class CreateSpaces < ActiveRecord::Migration[7.2]
  def change
    create_table :spaces do |t|
      t.string :tag_id
      t.datetime :time

      t.timestamps
    end
  end
end
