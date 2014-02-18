require 'settingslogic'

module Setting
	PATH = 'conf/setting.yml'

	def settings_path(path)
		@settings_path = path
		@setting = nil
	end

	def setting
		@setting ||= Setting.setting_for(@settings_path || PATH)
	end

	class << self
		def setting_for(path)
			setting = Class.new(Settingslogic) do
				source path
				namespace Aggregator::environment.to_s
			end
		end
	end
end