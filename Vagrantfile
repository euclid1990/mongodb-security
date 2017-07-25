Vagrant.configure("2") do |config|
  config.vm.define :database do |database|
    database.vm.box = "ubuntu/trusty64"
    database.vm.network :private_network, ip: "192.168.31.100"
    database.vm.hostname = "database.mongodb.local"
    database.vm.provision :shell, path: "provision-database", args: ENV['ARGS']
    database.vm.synced_folder "shared/", "/home/vagrant/shared", create: true

    database.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "1", "--memory", 1024]
    end
  end
end
