require 'app/controllers/application_controller'

require 'app/models/message_category'

class MessageCategoriesController < ApplicationController
	#Routing
	get '/' do
		index
	end

	get '/:handle' do
		view(params[:handle])
	end

	#Controlling
	def index
		haml :'message_categories/index', layout: :layout, locals: {:message_categories => MessageCategory.latest}
	end

	def view(handle)
		haml :'message_categories/view', layout: :layout, locals: {:message_category => MessageCategory.find_by(handle: handle)}
	end
end