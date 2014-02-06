require 'celluloid'

require 'app/models/Plugin'

require 'app/utils/Logging'
require 'app/utils/Setting'

require 'app/plugins/PluginValidator'
require 'app/plugins/PluginWorker'

class PluginManager
	include Logging
	include Setting
	include Celluloid

	# Stores all valid plugin models
	@plugin_definitions

	# Stores all plugin instances (threads)
	@plugin_instances

	def initialize
		logger.info 'Initializing plugin manager'

		@plugin_definitions = []
		@plugin_instances = []

		initialize_plugins
	end

	def defined_plugins
		@plugin_definitions
	end

	def loaded_plugins
		@plugin_instances
	end

	def run
		logger.debug 'Aggregating data from plugins.'

		if loaded_plugins.count <= 0
			logger.info 'No plugins loaded to aggregate data from.'
			Aggregator::shutdown
			return
		elsif loaded_plugins.count > 2
			pool_size = loaded_plugins.count
		else
			pool_size = 2
		end

		plugin_worker = PluginWorker.pool(size: pool_size)
		loaded_plugins.map { |p| plugin_worker.future.run(p) }.map(&:value)
	end

	private

	def initialize_plugins
		plugins = []
		logger.info 'Initializing plugins'

		search.each do |p|
			plugin = PluginValidator::validate p

			unless plugin.nil?
				plugins << plugin
			end
		end

		logger.info "Found #{plugins.count} valid plugins."

		plugins.each do |p|
			plugin = Plugin.find_or_initialize_by(name: p.name)

			plugin.update_attributes(
				class_name: p.class_name,
				conf_path: p.conf_path,
				class_path: p.class_path
			)

			@plugin_definitions << plugin
		end

		logger.info 'Persisted plugin information.' if plugins.count > 0

		@plugin_definitions.each do |p|
			begin
				require p.class_path
			rescue => e
				logger.warn "Couldn't parse file #{p.class_path}. Aggregator is not able to use the #{p.name} plugin."
				logger.debug e
				next
			end

			begin
				if Object::const_get(p.class_name).ancestors.include? PluginFrame
					instance = Object::const_get(p.class_name).spawn(p)
					@plugin_instances << instance
					logger.info "Plugin #{p.name} initialized"
				else
					raise
				end
			rescue => e
				logger.warn "Couldn't instantiate class #{p.class_name} or class is not a plugin. Aggregator is not able to use the #{p.name} plugin."
				logger.debug e
			end
		end

		logger.warn 'Found no useable plugin!' if @plugin_instances.empty?
	end

	# Search for plugins
	def search(directory = setting.plugin_folder)
		plugins = Dir.glob("#{directory}/**")

		if Aggregator::environment == :development
			plugins.each do |p|
				logger.debug "Found plugin folder #{p}. Validating plugin now."
			end
		end

		plugins
	end
end