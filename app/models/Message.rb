require 'active_record'

class Message < ActiveRecord::Base
	belongs_to :action

	scope :latest, -> { limit(20) }
end