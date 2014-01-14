require 'active_record'

class Plugin < ActiveRecord::Base
	has_many :actions
end