# -*- mode: ruby -*-
# vi: set ft=ruby :

$docker_swarm_init = <<SCRIPT
echo "============== Initializing swarm mode ====================="
docker swarm init --advertise-addr 192.168.99.101 --listen-addr 192.168.99.101:2377
sysctl -w vm.max_map_count=262144
SCRIPT

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true
  config.vm.provision "file", source: "~/.aws", destination: "$HOME/.aws"
  config.vm.provision "file", source: "~/.gnupg", destination: "$HOME/.gnupg"
  config.vm.provision "file", source: "~/.gitconfig", destination: "$HOME/.gitconfig"
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "$HOME/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "$HOME/.ssh/id_rsa.pub"
  config.vm.provision "file", source: "~/.ssh/personal.pem", destination: "$HOME/.ssh/personal.pem"
  config.vm.synced_folder ".", "/vagrant"
	config.vm.provision "docker"

	config.vm.define "node1", primary: true do |node1|
		node1.vm.hostname = 'node1'
		node1.vm.network :private_network, ip: "192.168.99.101"
		node1.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 9000]
			v.customize ["modifyvm", :id, "--name", "node1"]
		end
		node1.vm.provision :shell, inline: $docker_swarm_init
	end
end
