class CreateTransfers < ActiveRecord::Migration[7.2]
  def change
    create_table :transfers do |t|
      t.string :author
      t.text :detail

      t.timestamps
    end
  end
end
