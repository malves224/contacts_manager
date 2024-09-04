class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :latitude
      t.string :longitude
      t.string :complement
      t.string :number
      t.string :district
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
