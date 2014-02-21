require 'app/controllers/application_controller'

require 'app/models/action'

class ActionsController < ApplicationController
	#Routing
	get '/' do
		index
	end

	get '/:name/:plugin_id' do
		view(params)
	end

	#Controlling
	def index
		haml :'actions/index', layout: :layout, locals: {:actions => Action.latest}
	end

	def view(params)
		haml :'actions/view', layout: :layout, locals: {:action => Action.find_by(name: params['name'], plugin_id: params['plugin_id'])}
	end
end