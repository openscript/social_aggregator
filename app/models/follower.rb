require 'active_record'

class Follower < ActiveRecord::Base
	belongs_to :action

	scope :latest, -> { limit(20) }
end