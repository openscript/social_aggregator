require 'app/controllers/application_controller'

require 'app/models/message'

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