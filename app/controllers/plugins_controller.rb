require 'app/controllers/application_controller'

require 'app/models/plugin'

class PluginsController < ApplicationController
	#Routing
	get '/' do
		index
	end

	get '/:name' do
		view(params[:name])
	end

	#Controlling
	def index
		haml :'plugins/index', layout: :layout, locals: {plugins: Plugin.all}
	end

	def view(name)
		haml :'plugins/view', layout: :layout, locals: {:plugin => Plugin.find_by(name: handle)}
	end
end