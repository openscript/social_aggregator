require 'app/controllers/application_controller'

require 'app/models/message'

class MessagesController < ApplicationController
	# Routing
	get '/' do
		index(Message.latest)
	end

	get %r{/(^\d{0,3})} do
		index(Message.limit(params[:captures].first))
	end

	get '/:handle' do
		view(Message.find_by(handle: params[:handle]))
	end

	#Controlling
	def index(records)
		haml :'messages/index', layout: :layout, locals: {:messages => records}
	end

	def new
		Message.new
	end

	def create(message)
		puts message
	end

	def view(record)
		haml :'messages/view', layout: :layout, locals: {:message => record}
	end
end