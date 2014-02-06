require 'active_record'

class MessageCategory < ActiveRecord::Base
	belongs_to :action

	has_many :logs, as: :loggable

	scope :latest, -> { limit(20) }
end