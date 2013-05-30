require 'active_record'

class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.string :title
			t.text :message

			t.references :plugin

			t.timestamps
		end
	end
end