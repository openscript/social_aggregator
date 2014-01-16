require 'active_record'

class CreateMessages < ActiveRecord::Migration
	def change
		create_table :messages do |t|
			t.string :title, :null => false
			t.text :summary
			t.text :content
			t.string :fingerprint, :null => false
			t.string :reference_url
			t.datetime :published_at

			t.references :message_category, :null => false

			t.timestamps
		end

		add_index(:messages, :fingerprint, :unique => true)
	end
end