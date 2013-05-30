require 'active_record'

class Follower < ActiveRecord::Base
	belongs_to :plugin
end