require 'active_record'

class CreateMessageCategories < ActiveRecord::Migration
	def change
		create_table :message_categories do |t|
			t.string :name, :null => false
			t.text :description
			t.string :handle, :null => false

			t.references :action, :null => false

			t.timestamps
		end

		add_index(:message_categories, :handle, :unique => true)
	end
end