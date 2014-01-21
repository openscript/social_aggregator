require 'app/controllers/ApplicationController'

require 'app/models/Message'

class MessagesController < ApplicationController
	#Routing
	get '/' do
		index
	end

	#Controlling
	def index
		haml :'messages/index', :locals => {:messages => Message.latest}, :layout => :layout
	end

	def new
		Message.new
	end

	def create(message)
		puts message
	end
end