# /Vagrantfile
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	
	config.vm.box = "ubuntu/trusty64"
	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.synced_folder "app/", "/vagrant/app", :nfs => true, :nfs => { :mount_options => ["dmode=777","fmode=777"] }
	config.vm.network :private_network, ip: "192.168.58.102"
	config.vm.provider :virtualbox do |vb|
		vb.gui = false
		vb.customize ["modifyvm", :id, "--name", "vm-name", "--memory", "1024"]
	end

	config.vm.provision "puppet" do |puppet|
		puppet.manifests_path = "manifests"
		puppet.manifest_file = "provision.pp"
		puppet.module_path = "modules"
	end

end
