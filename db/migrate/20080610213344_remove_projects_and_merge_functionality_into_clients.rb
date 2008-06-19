class RemoveProjectsAndMergeFunctionalityIntoClients < ActiveRecord::Migration
  def self.up
  	rename_column :line_items, :project_id, :client_id
	  rename_column :invoices, :project_id, :client_id
  	drop_table :projects
  end
  

  def self.down
		create_table "projects" do |t|
		  t.string   "name"
		  t.integer  "client_id"
		  t.datetime "created_at"
		  t.datetime "updated_at"
		end
	  rename_column :invoices, :client_id, :project_id
  	rename_column :line_items, :client_id, :project_id
  end
end
