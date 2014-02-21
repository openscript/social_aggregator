require 'active_record'

class Action < ActiveRecord::Base
	belongs_to :plugin

	has_many :followers
	has_many :message_categories
	has_many :logs, as: :loggable
	
	scope :latest, -> { limit(20) }

	# Returns the time in seconds to the last occurance
	def last_occurance
		last_log = self.logs.order(:created_at).last
		unless last_log.nil?
			Time.now - last_log.created_at
		else
			nil
		end
	end
end