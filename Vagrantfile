# -*- mode: ruby -*-
# vi: set ft=ruby :

$docker_swarm_init = <<SCRIPT
echo "============== Initializing swarm mode ====================="
docker swarm init --advertise-addr 192.168.99.101 --listen-addr 192.168.99.101:2377
docker swarm join-token --quiet worker > /vagrant/worker_token
SCRIPT

$docker_swarm_join_worker = <<SCRIPT
echo "============== Joining swarm cluster as worker ====================="
docker swarm join --token $(cat /vagrant/worker_token) 192.168.99.101:2377
SCRIPT

Vagrant.configure("2") do |config|
	config.vm.box = "ubuntu/xenial64"
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true
	config.vm.provision "docker"

	config.vm.define "node1", primary: true do |node1|
		node1.vm.hostname = 'node1'
		node1.vm.network :private_network, ip: "192.168.99.101"
		node1.vm.provider :virtualbox do |v|
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--memory", 10000]
			v.customize ["modifyvm", :id, "--name", "node1"]
		end
		node1.vm.provision :shell, inline: $docker_swarm_init
		# node1.vm.provision "docker" do |d|
		# 	d.run "visualizer",
		# 		image: "dockersamples/visualizer",
		# 		args: "-it -p 9999:8080 -v /var/run/docker.sock:/var/run/docker.sock"
    #   d.run "Portainer",
		# 		image: "portainer/portainer",
    #     cmd: "-H unix:///var/run/docker.sock --no-auth",
		# 		args: "-it -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock"
		# end
	end

	# config.vm.define "node2" do |node2|
	# 	node2.vm.hostname = 'node2'
	# 	node2.vm.network :private_network, ip: "192.168.99.102"
	# 	node2.vm.provider :virtualbox do |v|
	# 		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	# 		v.customize ["modifyvm", :id, "--memory", 4000]
	# 		v.customize ["modifyvm", :id, "--name", "node2"]
	# 	end
	# 	node2.vm.provision :shell, inline: $docker_swarm_join_worker
	# end

end
