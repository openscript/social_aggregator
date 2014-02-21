require 'active_record'

class Plugin < ActiveRecord::Base
	has_many :actions
	
	scope :latest, -> { limit(20) }
end