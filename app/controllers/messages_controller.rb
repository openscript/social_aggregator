require 'app/controllers/application_controller'

require 'app/models/message'

class MessagesController < ApplicationController
	#Routing
	get '/' do
		index
	end

	get '/:handle' do
		view(params[:handle])
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

	def view(handle)
		haml :'messages/view', layout: :layout, locals: {:message => Message.find_by(handle: handle)}
	end
end