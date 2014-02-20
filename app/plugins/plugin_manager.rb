require 'celluloid'

require 'app/models/plugin'

require 'app/utils/logging'
require 'app/utils/setting'

require 'app/plugins/plugin_validator'
require 'app/plugins/plugin_worker'

class PluginManager
	include Logging
	include Setting
	include Celluloid

	attr_reader :plugin_definitions, :plugin_instances

	def initialize
		logger.info 'Initializing plugin manager'
		initialize_plugins
	end

	def run
		logger.debug 'Aggregating data from plugins.'

		if plugin_instances.count <= 0
			logger.info 'No plugins loaded to aggregate data from.'
			Aggregator::shutdown
			return
		elsif plugin_instances.count > 2
			pool_size = plugin_instances.count
		else
			pool_size = 2
		end

		plugin_worker = PluginWorker.pool(size: pool_size)
		plugin_instances.map{ |p| plugin_worker.future.run(p) }.map(&:value)
	end

	private

	def initialize_plugins
		logger.info 'Initializing plugins'

		plugins = search_for_plugins.map{ |p| PluginValidator::validate p }.compact
		logger.info "Found #{plugins.count} valid plugins."

		@plugin_definitions = plugins.map do |p|
			Plugin.find_or_initialize_by(name: p.name).tap do |m|
				m.update_attributes(
					class_name: p.class_name,
					conf_path: p.conf_path,
					class_path: p.class_path
				)
			end
		end
		logger.info 'Persisted plugin information.' if plugins.count > 0

		@plugin_instances = plugin_definitions.map do |p|
			begin
				require p.class_path
				begin
					stub = Object::const_get(p.class_name)
					if stub.ancestors.include?(PluginFrame) && stub.methods.include?(:run)
						stub.spawn(p)
					else
						raise
					end
				rescue => e
					logger.warn "Couldn't instantiate class #{p.class_name}, class is not a plugin or it doesn't contain a run method. Aggregator is not able to use the #{p.name} plugin."
					logger.debug e
				end
			rescue => e
				logger.warn "Couldn't parse file #{p.class_path}. Aggregator is not able to use the #{p.name} plugin."
				logger.debug e
			end
		end

		logger.warn 'Found no useable plugin!' if @plugin_instances.empty?
	end

	# Search for plugins in a given directory
	def search_for_plugins(directory = setting.plugin_folder)
		Dir.glob("#{directory}/**").tap do |plugins|
			if Aggregator::environment == :development
				plugins.each do |plugin|
					logger.debug "Found plugin folder #{plugin}. Validating plugin now."
				end
			end
		end
	end
end