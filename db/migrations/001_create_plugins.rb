require 'active_record'

class CreatePlugins < ActiveRecord::Migration
	def up
		create_table :plugins do |t|
			t.string :name, null: false
			t.string :class_name, null: false
			t.string :conf_path, null: false
			t.string :class_path, null: false

			t.timestamps
		end

		add_index(:plugins, :name, unique: true)
		add_index(:plugins, :class_name, unique: true)
		add_index(:plugins, :class_path, unique: true)
	end

	def down
		drop_table :plugins
	end
end