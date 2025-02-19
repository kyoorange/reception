class AddYummyToTransfers < ActiveRecord::Migration[7.2]
  def change
    add_column :transfers, :yummy, :string
  end
end
