class DropTransfersTable < ActiveRecord::Migration[7.2]
  def change
  end
  def up
    drop_table :transfers
  end

  def down
    create_table :transfers do |t|
      t.string :example_column
      t.timestamps
      t.string :author
      t.text :detail
      t.string :yummy
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
