require 'active_record'

class CreateFollowers < ActiveRecord::Migration
	def change
		create_table :followers do |t|
			t.string :name, :null => false
			t.string :url

			t.references :action, :null => false

			t.timestamps
		end
	end
end