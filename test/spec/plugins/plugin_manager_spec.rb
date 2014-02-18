require 'test/spec/SpecHelper'

describe PluginManager do
	it 'should have two plugin definitions' do
		plugin_manager = PluginManager.new
		plugin_manager.defined_plugins.count.should eq 2
	end
end