require 'active_record'

class Action < ActiveRecord::Base
	belongs_to :plugin

	has_many :followers
	has_many :message_categories
	has_many :logs
end