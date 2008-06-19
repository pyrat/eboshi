class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :email
      t.string :contact
      t.string :phone

      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
