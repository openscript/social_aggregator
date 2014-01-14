require 'active_record'

class CreateActions < ActiveRecord::Migration
	def change
		create_table :actions do |t|
			t.string :name, :null => false
			t.text :description
			t.string :reference

			t.references :plugin, :null => false

			t.timestamps
		end

		add_index(:actions, [:name, :plugin_id], :unique => true)
	end
end