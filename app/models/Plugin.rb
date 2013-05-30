require 'active_record'

class Plugin < ActiveRecord::Base
	has_many :followers
	has_many :messages
end