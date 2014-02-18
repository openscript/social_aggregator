require 'app/controllers/application_controller'

class FollowersController < ApplicationController
	def new
		Follower.new
	end
end