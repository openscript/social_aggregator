require 'active_record'

class Message < ActiveRecord::Base
	belongs_to :plugin

	scope :latest, limit(20)
end