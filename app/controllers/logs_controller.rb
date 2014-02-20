require 'app/controllers/application_controller'

require 'app/models/log'

class LogsController < ApplicationController
	#Routing
	get '/' do
		index
	end

	get '/:id' do
		view(params['id'])
	end

	#Controlling
	def index
		haml :'logs/index', layout: :layout, locals: {:logs => Log.latest}
	end

	def view(id)
		haml :'logs/view', layout: :layout, locals: {:log => Log.find_by(id: id)}
	end
end