require 'active_record'

class CreateLogs < ActiveRecord::Migration
	def up
		create_table :logs do |t|
			t.string :title
			t.text :description

			t.references :loggable, null: false, polymorphic: true

			t.timestamps
		end
	end

	def down
		drop_table :logs
	end
end