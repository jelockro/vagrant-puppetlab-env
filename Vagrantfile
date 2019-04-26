Vagrant.require_version ">= 1.5.0"
require 'vagrant-hosts'
require 'vagrant-auto_network'

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
  end
  config.vm.define :puppetmaster do |node|
    node.vm.box =  "centos/7"
    node.vm.hostname = 'puppetmaster.debug.vlan'
    node.vm.network :private_network, :auto_network => true
    node.vm.provision :hosts
      # # Master
    config.vm.network "forwarded_port", guest: 8140, host: 8140
    # # Console
    config.vm.network "forwarded_port", guest: 443, host: 443
    # # Classifier
    config.vm.network "forwarded_port", guest: 4433, host: 4433
    # # PuppetDB
    config.vm.network "forwarded_port", guest: 8081, host: 8081
    # # Orchestrator
    config.vm.network "forwarded_port", guest: 8142, host: 8142
    # # Code manager
    config.vm.network "forwarded_port", guest: 8170, host: 8170
    config.vm.network "forwarded_port", guest: 3000, host: 3000
    config.vm.network "forwarded_port", guest: 8081, host: 8081
    config.vm.synced_folder "./provision_data", "/provision_data", type: "rsync"
    config.vm.synced_folder "./dev", "/home/vagrant/dev"
    config.vm.synced_folder "./updates", "/home/vagrant/updates"
    if Vagrant.has_plugin?("vagrant-gatling-rsync")
      config.gatling.rsync_on_startup = false
    end
    config.vm.provision :shell, :path => "pre-provision.sh"
    config.vm.provision :shell, :path => "install_puppet_enterprise.sh"
  end
  

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"


  # config.vm.provision :shell, :path => "install_ruby.sh"
  # config.vm.provision :shell, :path => "install_nginx.sh"
end