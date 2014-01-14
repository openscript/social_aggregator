require 'active_record'

class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.string :title
			t.text :message

			t.references :action, :null => false

			t.timestamps
		end
	end
end