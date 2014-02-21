require 'rack'
require 'sinatra/base'

require 'app/controllers/application_controller'
require 'app/controllers/actions_controller'
require 'app/controllers/followers_controller'
require 'app/controllers/logs_controller'
require 'app/controllers/message_categories_controller'
require 'app/controllers/messages_controller'
require 'app/controllers/plugins_controller'

module Router
	def self.map
		Rack::URLMap.new({
			"/" => ApplicationController.new,
			"/actions" => ActionsController.new,
			"/followers" => FollowersController.new,
			"/logs" => LogsController.new,
			"/message_categories" => MessageCategoriesController.new,
			"/messages" => MessagesController.new,
			"/plugins" => PluginsController.new
		})
	end
end