class AddRateToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :rate, :integer
  end

  def self.down
  	remove_column :users, :rate
  end
end
