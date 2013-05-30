require 'app/controllers/ApplicationController'

require 'app/models/Message'

class MessagesController < ApplicationController
	#Routing
	get '/' do
		haml :'messages/index', :locals => {:messages => index}, :layout => :layout
	end

	#Controlling
	def index
		Message.latest
	end

	def new
		Message.new
	end

	def create(message)
		puts message
	end
end