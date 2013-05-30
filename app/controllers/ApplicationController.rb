require 'sinatra/base'
require 'sinatra/namespace'
require 'haml'

class ApplicationController < Sinatra::Base
	#Setting
	set :logging, false				# disable rack logging, because webrick is logging this already to a log file
	set :views, "app/views"

	before do
		content_type 'text/xml', :charset => 'utf-8'
	end
	
	#Routing
	get '/' do
		content_type 'text/html', :charset => 'utf-8'
		haml :index, :layout => false, :locals => {:version => Aggregator::version}
	end

	#Controlling 
	def index
	end
end