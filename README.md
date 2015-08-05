vm-pp
=====
A bare bones LAMP VM spinup. It uses Vagrant, VirtualBox and Puppet.


## Step-by-step guide

### 1. Clone the repo
```
$ git clone git@github.com:radub/vm-pp.git
```

### 2. Customize your VM config file
```
$ cd vm-pp
$ vim Vagrantfile
 
# there are a few things you can configure such as vm-name and ip just to name a few
```

The Vagrantfile should look something like this:
```
# Vagrantfile
VAGRANTFILE_API_VERSION = "2"
 
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
        config.vm.box = "ubuntu/trusty64"
        config.vm.network "forwarded_port", guest: 80, host: 8080
        config.vm.synced_folder "../", "/vagrant", :nfs => true, :nfs => { :mount_options => ["dmode=777","fmode=777"] }
         
        # look for private_network. You can specify a 192.168.58.xxx ip so you can access the VM on your local computer.
        config.vm.network :private_network, ip: "192.168.58.102"
        config.vm.provider :virtualbox do |vb|
                vb.gui = false
                 
                # look for vm-name. Change this to {your-project-name} so you won't have naming conflicts when you want to spin-up another VM. Name should be unique and should contain only [a-zA-Z0-9-_]
                vb.customize ["modifyvm", :id, "--name", "vm-name", "--memory", "1024"]
        end
 
        config.vm.provision "puppet" do |puppet|
                puppet.manifests_path = "manifests"
                puppet.manifest_file = "provision.pp"
                puppet.module_path = "modules"
        end
end
```
<sup>read the comments above every line in the Vagrantfile above</sup>

## 3. Create the app directory
```
# at the same level with vm-pp directory create another dir named app
$ mkdir app
```

## 4. Prepare for spin-up
Make sure you read this before going forward: http://docs.vagrantup.com/v2/cli/

## 5. Spin-up the VM
```
# make sure you are inside vm-pp directory then run the command below
$ vagrant up

# follow the logs on the screen as you may find useful details
# at some point you may be asked for your administrator password
```

## 6. Add VM to hosts file
```
# this step is optional but nice to have
# add the below line at the end of your hosts file
# you will be able to use this alias to access the VM web root from you browser instead of the IP
 
192.168.58.xxx {projet-name}.local

# for unix
$ vim /etc/hosts
 
# for windows (make sure you edit the hosts file as administrator)
c:\Windows\System32\Drivers\etc\hosts 
```

## 7. You're done! (smile)
To test everything works, create an index.html file inside the app directory, then try to access it in you browser using: 
```
http://{projet-name}.local
```
