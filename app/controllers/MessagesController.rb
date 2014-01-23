require 'app/controllers/ApplicationController'

require 'app/models/Message'

class MessagesController < ApplicationController
	#Routing
	get '/' do
		index
	end

	#Controlling
	def index
		haml :'messages/index', layout: :layout, locals: {:messages => Message.latest}
	end

	def new
		Message.new
	end

	def create(message)
		puts message
	end
end