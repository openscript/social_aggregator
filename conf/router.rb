require 'rack'
require 'sinatra/base'

require 'app/controllers/ApplicationController'
require 'app/controllers/MessagesController'
require 'app/controllers/PluginsController'

module Router
	def self.map
		Rack::URLMap.new({
			"/" => ApplicationController.new,
			"/messages" => MessagesController.new,
			"/plugins" => PluginsController.new
		})
	end
end