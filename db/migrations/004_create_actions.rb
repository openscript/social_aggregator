require 'active_record'

class CreateActions < ActiveRecord::Migration
	def change
		create_table :actions do |t|
			t.string :name, :null => false
			t.text :description

			t.references :plugin, :null => false

			t.timestamps
		end
	end
end