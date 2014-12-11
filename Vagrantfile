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
      d.env = {
          :AWS_ACCESS_KEY_ID => ENV['AWS_ACCESS_KEY_ID'],
          :AWS_SECRET_ACCESS_KEY => ENV['AWS_SECRET_ACCESS_KEY']
      }
      puts d.env
    end
    # Sync the project directory using rsync
    app.vm.synced_folder '.', '/home/vagrant/wubot', :type => 'rsync'
  end

end
