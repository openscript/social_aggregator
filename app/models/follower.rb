require 'active_record'

class Follower < ActiveRecord::Base
	belongs_to :action
end