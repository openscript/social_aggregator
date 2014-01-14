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

		# Check if there is a configuration file.
		conf_path = "#{path}/#{validator.setting.plugin_configuration}"
		unless File.file? conf_path
			validator.logger.warn "Couldn't find plugin configuration file of #{path} in #{conf_path}"
			return
		end

		# Check if there is a class file.
		class_path = "#{path}/#{validator.setting.plugin_class_file}"
		unless File.file? class_path
			validator.logger.warn "Couldn't find plugin class file of #{path} in #{class_path}"
		end

		# Try to load configuration file.
		begin
			conf = YAML.load_file(conf_path)
			unless conf
				raise
			end
		rescue
			validator.logger.error "The plugin configuration file #{conf_path} is not valid! Please check the configuration."
			return
		end

		# Check if plugin is active.
		if conf[Aggregator::environment.to_s].has_key? 'active'
			unless conf[Aggregator::environment.to_s]['active']
				validator.logger.warn "The plugin (#{path}) has been set to be inactive."
				return
			end
		end

		# Check if there are the required options.
		REQUIRED_ATTR.each do |a|
			unless conf[Aggregator::environment.to_s].has_key? a
				validator.logger.error "Unfortunately the plugin configuration file #{conf_path} dosen't include an attribute, which is called #{a} and required."
				return
			end
		end

		# Initialize plugin model.
		plugin = Plugin.new
		plugin.name = conf[Aggregator::environment.to_s]['plugin_name']
		plugin.class_name = conf[Aggregator::environment.to_s]['class_name']
		plugin.conf_path = conf_path
		plugin.class_path = class_path

		validator.logger.debug "Plugin #{conf['plugin_name']} in #{path} is valid and the definition has been loaded."

		# Return plugin.
		plugin
	end
end