

Vagrant.configure("2") do |config|
    config.vm.box = "centos65"
    config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network "private_network", ip: "192.168.33.10"

    config.vm.provision :shell, :path => "bootstrap.sh"

    config.vm.synced_folder "./Projects/", "/Projects"

    config.ssh.username = 'root'
    config.ssh.password = 'vagrant'
    config.ssh.insert_key = 'true'

end