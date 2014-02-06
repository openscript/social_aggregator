require 'ostruct'
require 'optparse'

class ArgumentParser
	# Helps to parse the program arguments
	def self.parse(args)
		arguments = OpenStruct.new

		arguments.environment = :production
		arguments.verbose = false
		arguments.quiet = false
		arguments.console = false

		parser = OptionParser.new do |parser|
			parser.banner = "Social Aggregator - Version: #{Aggregator::AGGREGATOR_VERSION}\nInitiated by http://openscript.ch/\n\nUsage: aggregator.rb [arguments]"
			parser.separator ''

			parser.on('-e [name]', '--environment [name]', [:development, :test, :production], 'Select an environment', '(development, test or production)') do |e|
				arguments.environment = e
			end

			parser.on('-q', '--quiet', 'No output to stdout') do |q|
				arguments.quiet = q
			end

			parser.on('-v', '--verbose', 'Run verbosely') do |v|
				arguments.verbose = v
			end

			parser.on('-c', '--console', 'Start a console session') do |c|
				arguments.console = c
			end

			parser.on('-h', '--help', 'Show this message') do 
				puts parser
				exit
			end

			parser.on('--version', 'Show version') do
				puts Aggregator::AGGREGATOR_VERSION
				exit
			end

		end.parse!(args)

		arguments
	end
end