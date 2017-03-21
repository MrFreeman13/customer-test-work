class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :building
      t.string :street
      t.string :city
      t.string :country
      t.string :postal_code
      t.integer :appointment_id

      t.timestamps null: false
    end
  end
end
