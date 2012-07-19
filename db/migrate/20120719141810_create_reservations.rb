class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :company_id
      t.integer :inviter_id
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
