# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.6.5'

def populate_from_secrets
  secrets = {}
  File.open('secrets.env', 'r') do |infile|
    infile.each_line do |line|
      next if line.start_with?('#')
      key, value = line.strip.split('=')
      secrets[key] = value
    end
  end
  secrets
end

Vagrant.configure(2) do |config|

  config.vm.define 'wubot' do |wubot|
    # Sync the project directory using rsync
    wubot.vm.provider 'docker' do |d|
      d.build_dir = './docker/'
      d.cmd = ['/sbin/my_init', '--enable-insecure-key']
      d.has_ssh = true
      d.env = populate_from_secrets
      d.volumes = ['/var/log:/var/log']
      # vagrant options
      d.vagrant_machine = 'docker-host'
      d.vagrant_vagrantfile = '../docker/docker-host/Vagrantfile'
    end
    # Sync the project directory using rsync
    wubot.vm.synced_folder './hubot-scripts', '/opt/hubot/scripts', :type => 'rsync'
    wubot.ssh.username = 'root'
    wubot.ssh.private_key_path = './phusion-insecurekey'
  end

end
