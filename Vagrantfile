# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.6.5'

def populate_from_secrets
  secrets = {}
  begin
    infile = File.open('secrets.env', 'r')
  rescue
    warn "[\e[1m\e[31mWARNING\e[0m]: File secrets.env not found in #{Dir.pwd}!"
    warn "Run: make secrets DEST=#{Dir.pwd}"
    warn 'Returning empty secrets hash'
    return secrets
  end
  infile.each_line do |line|
    next if line.start_with?('#')
    key, value = line.strip.split('=')
    secrets[key] = value
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
      d.env = {:HUBOT_BOTNAME => 'wubot',
               :HUBOT_HIPCHAT_ROOMS => 'hipchat-integrations'
              }.merge!(populate_from_secrets)
      d.volumes = ['/var/log:/var/log']
      # vagrant options
      d.vagrant_machine = 'docker-host'
      d.vagrant_vagrantfile = '../docker/docker-host/Vagrantfile'
    end
    # Sync the project directory using rsync
    wubot.vm.synced_folder './hubot-scripts', '/opt/hubot/scripts', :type => 'rsync'
    # setup ssh for docker container
    wubot.ssh.username = 'root'
    wubot.ssh.private_key_path = './docker/build/phusion-insecurekey'
  end

end
