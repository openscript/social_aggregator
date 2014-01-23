require 'active_record'

class CreateFollowers < ActiveRecord::Migration
	def up
		create_table :followers do |t|
			t.string :username, null: false
			t.string :name
			t.string :profile_url, null: false
			t.string :image_url

			t.references :action, null: false

			t.timestamps
		end

		add_index(:followers, [:username, :action_id], unique: true)
		add_index(:followers, :profile_url, unique: true)
	end

	def down
		drop_table :followers
	end
end