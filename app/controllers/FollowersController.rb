require 'ApplicationController'

class FollowersController < ApplicationController
	def new
		Follower.new
	end
end