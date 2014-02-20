require 'active_record'

class Log < ActiveRecord::Base
	belongs_to :loggable, polymorphic: true

	scope :latest, -> { limit(20) }
end