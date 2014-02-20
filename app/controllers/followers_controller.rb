require 'app/controllers/application_controller'

require 'app/models/follower'

class FollowersController < ApplicationController
	#Routing
	get '/' do
		index
	end

	get '/:username/:action_id' do
		view(params)
	end

	#Controlling
	def index
		haml :'followers/index', layout: :layout, locals: {:follower => Follower.latest}
	end

	def view(params)
		haml :'followers/view', layout: :layout, locals: {:follower => Follower.find_by(username: params['username'], action_id: params['action_id'])}
	end
end