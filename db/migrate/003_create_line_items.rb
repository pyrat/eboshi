class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :project_id
      t.integer :user_id
      t.datetime :start
      t.datetime :end
      t.integer :rate
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :line_items
  end
end
