class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :author
      t.text :content
      t.string :type

      t.timestamps
    end
  end
end
