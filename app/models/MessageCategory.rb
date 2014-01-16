require 'active_record'

class MessageCategory < ActiveRecord::Base
	belongs_to :action

	scope :latest, -> { limit(20) }
end