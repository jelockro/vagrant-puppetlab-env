Vagrant.require_version ">= 1.5.0"
require 'vagrant-hosts'
#require 'vagrant-auto_network'

nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node
    
    config.vm.define node_name do |config|
      # configure box settings
      config.vm.box        =  node_values[':box']
      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", node_values[':memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
      end

      # configure network settings  
      config.vm.hostname = node_name
      config.vm.network :private_network, ip: node_values[':ip']
      
      # configure port settings
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
          host:  port[':host'],
          guest: port[':guest'],
          id:    port[':id']
      end
      
      # copy folders and files
      config.vm.synced_folder "./provision_data", "/provision_data", type: "rsync"
      config.vm.synced_folder "./dev", "/home/vagrant/dev"
      config.vm.synced_folder "./updates", "/home/vagrant/updates"
      if Vagrant.has_plugin?("vagrant-gatling-rsync")
        config.gatling.rsync_on_startup = false
      end

      # run provisioning scripts
      config.vm.provision :shell, :path => "pre-provision.sh"
      config.vm.provision :shell, :path => "install_puppet_enterprise.sh"
    end
  end
end