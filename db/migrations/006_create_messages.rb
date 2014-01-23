require 'active_record'

class CreateMessages < ActiveRecord::Migration
	def up
		create_table :messages do |t|
			t.string :title, null: false
			t.text :summary
			t.text :content
			t.string :handle, null: false
			t.string :reference_url
			t.datetime :published_at

			t.references :message_category, null: false

			t.timestamps
		end

		add_index(:messages, :handle, unique: true)
	end

	def down
		drop_table :messages
	end
end