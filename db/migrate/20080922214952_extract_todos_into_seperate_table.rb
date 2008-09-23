class ExtractTodosIntoSeperateTable < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.integer  "client_id",  :limit => 11
      t.integer  "user_id",    :limit => 11
      t.text     "notes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    execute "INSERT INTO todos (client_id, user_id, notes, created_at, updated_at) SELECT client_id, user_id, notes, created_at, updated_at FROM line_items WHERE type='Todo'"
    execute "DELETE FROM line_items WHERE type='Todo'"
  end

  def self.down
    execute "INSERT INTO line_items (client_id, user_id, notes, created_at, updated_at, type) SELECT client_id, user_id, notes, created_at, updated_at, 'Todo' FROM todos"
    drop_table :todos
  end
end
