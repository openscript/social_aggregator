VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "debian_minimal_ruby"
	config.vm.box_url = ""
	config.vm.network :forwarded_port, guest: 12001, host: 12001
	config.vm.network :private_network, ip: "192.168.12.1"
end