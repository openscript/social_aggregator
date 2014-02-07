require 'active_record'

class Action < ActiveRecord::Base
	belongs_to :plugin

	has_many :followers
	has_many :message_categories
	has_many :logs, as: :loggable

	# Returns the time in seconds to the last occurance
	def last_occurance
		last_log = self.logs.order(:created_at).last
		unless last_log.nil?
			Time.now - self.logs.order(:created_at).last.created_at
		else
			nil
		end
	end
end