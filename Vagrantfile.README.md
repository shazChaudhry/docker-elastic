### Vagrant Box prerequisites
- The user has admin privileges on their development machines
- At least 20GB of free RAM is available on the machine. Otherwise, Vagrantfile will need editing to adjust the available memory:
  - `v.customize ["modifyvm", :id, "--memory", <MEMORY_ALLOCATION>]`
- Latest version of [Oracle VM VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Latest version of [Git for Windows](https://git-scm.com/downloads)
- Latest version of [Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)
  - Install Vagrant Host Manager plugin by running the following command in the Git Bash terminal. This plugin updates the host files on both guest and host machines:
    - `vagrant plugin install vagrant-hostmanager`

### Start vagrant boxes
- `vagrant destroy --force`
- `vagrant up --color`
