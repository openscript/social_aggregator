require 'rack'
require 'sinatra/base'

require 'app/controllers/application_controller'
require 'app/controllers/messages_controller'
require 'app/controllers/plugins_controller'

module Router
	def self.map
		Rack::URLMap.new({
			"/" => ApplicationController.new,
			"/messages" => MessagesController.new,
			"/plugins" => PluginsController.new
		})
	end
end