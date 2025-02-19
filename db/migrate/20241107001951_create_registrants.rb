class CreateRegistrants < ActiveRecord::Migration[7.2]
  def change
    create_table :registrants do |t|
      t.text :city
      t.text :address1
      t.text :address2
      t.text :belongs
      t.text :details
      t.text :email
      t.text :found
      t.text :job
      t.text :name
      t.text :number
      t.text :phone
      t.text :prefecture
      t.text :pronunciation

      t.timestamps
    end
  end
end
