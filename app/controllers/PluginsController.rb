require 'app/controllers/ApplicationController'

require 'app/models/Message'

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
		haml :'plugins/index', layout: :layout, locals: {plugins: Aggregator::plugin_manager}
	end

	def view(name)
		plugins = Aggregator::plugin_manager.loaded_plugins.map{ |i| i.class.name.parameterize}
		if plugins.include? name.parameterize
			haml :'plugins/view', locals: {plugin: "bla"}, layout: :layout
		else
			404
		end
	end
end