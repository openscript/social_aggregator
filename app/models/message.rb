require 'active_record'

class Message < ActiveRecord::Base
	belongs_to :message_category

	scope :latest, -> { limit(20) }
end