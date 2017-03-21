class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :specialist
      t.datetime :scheduled_time
      t.integer :user_id
      t.integer :address_id

      t.timestamps null: false
    end

    add_index :appointments, :specialist
  end
end
