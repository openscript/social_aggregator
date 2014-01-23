require 'active_record'

class CreateActions < ActiveRecord::Migration
	def up
		create_table :actions do |t|
			t.string :name, null: false
			t.text :description

			t.references :plugin, null: false

			t.timestamps
		end

		add_index(:actions, [:name, :plugin_id], unique: true)
	end

	def down
		drop_table :actions
	end
end