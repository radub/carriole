# /Vagrantfile
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	
	config.vm.box = "puppetlabs/ubuntu-12.04-64-puppet"
	config.vm.network "forwarded_port", guest: 80, host: 8080
	config.vm.synced_folder "../site", "/vagrant", :nfs => true, :nfs => { :mount_options => ["dmode=777","fmode=777"] }
	config.vm.network :private_network, ip: "192.168.58.100"
        config.vm.provider :virtualbox do |vb|
                vb.gui = false
                vb.customize ["modifyvm", :id, "--name", "symf2test", "--memory", "1024"]
        end

	config.vm.provision "puppet" do |puppet|
    		puppet.manifests_path = "manifests"
		puppet.manifest_file  = "provision.pp"
	end

end
