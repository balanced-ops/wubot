# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.6.5'

Vagrant.configure(2) do |config|

  config.vm.define 'wubot' do |app|

    app.vm.provider 'docker' do |d|
      d.build_dir = './docker/'
      d.has_ssh = true
      # vagrant options
      d.vagrant_machine = 'docker-host'
      d.vagrant_vagrantfile = '../docker/docker-host/Vagrantfile'
    end

    # Sync the project directory using rsync
    app.vm.synced_folder '.', '/home/vagrant/wubot', :type => 'rsync'
  end

end
