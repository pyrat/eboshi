class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :project_id
      t.integer :total

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
