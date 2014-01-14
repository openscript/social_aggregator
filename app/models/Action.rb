require 'active_record'

class Action < ActiveRecord::Base
	belongs_to :plugin
	has_many :followers
	has_many :messages
end