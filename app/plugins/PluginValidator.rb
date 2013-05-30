require 'yaml'

require 'app/utils/Logging'
require 'app/utils/Setting'

require 'app/models/Plugin'

class PluginValidator
	include Logging
	include Setting

	REQUIRED_ATTR = %w(plugin_name class_name)

	def self.validate(path)
		validator = self.new

		return unless File.directory? path

		conf_path = "#{path}/#{validator.setting.plugin_configuration}"
		unless File.file? conf_path
			validator.logger.warn "Couldn't find plugin configuration file of #{path} in #{conf_path}"
			return
		end

		class_path = "#{path}/#{validator.setting.plugin_class_file}"
		unless File.file? class_path
			validator.logger.warn "Couldn't find plugin class file of #{path} in #{class_path}"
		end

		begin
			conf = YAML.load_file(conf_path)
			unless conf
				raise
			end
		rescue
			validator.logger.error "The plugin configuration file #{conf_path} is not valid! Please check the configuration."
			return
		end

		REQUIRED_ATTR.each do |a|
			unless conf[Aggregator::environment.to_s].has_key?(a)
				validator.logger.error "Unfortunately the plugin configuration file #{conf_path} dosen't include an attribute, which is called #{a}."
				return
			end
		end

		plugin = Plugin.new
		plugin.name = conf[Aggregator::environment.to_s]['plugin_name']
		plugin.class_name = conf[Aggregator::environment.to_s]['class_name']
		plugin.conf_path = conf_path
		plugin.class_path = class_path

		validator.logger.debug "Plugin #{conf['plugin_name']} in #{path} is valid"

		plugin
	end
end