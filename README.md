# Wubot

Balanced Hubot installation

## Scripting

The `hubot-scripts` directory contains all the hubot scripts that will ultimately end up in the `${ hubot_dir }/scripts` directory. Just add your coffee scripts into the `hubot-scripts`.

Read this: https://github.com/github/hubot/blob/master/docs/scripting.md#scripting for more information

## Hacking

The `Vagrantfile` attached will use a `docker-host` machine as a host to build a `docker` container that runs the
`wubot` installation.

`vagrant ssh` will ssh into the docker container

### Re-using a different base image

Currently, the `Vagrantfile` uses a `build_dir` setting:

```ruby
config.vm.define 'wubot' do |wubot|
  # Sync the project directory using rsync
  wubot.vm.provider 'docker' do |d|
     d.build_dir = './docker/'
     # ...
  end
end
```

You can read about this here: http://docs.vagrantup.com/v2/docker/configuration.html

If you want to iterate on an existing image, you must change the `Dockerfile` to use:

```dockerfile
FROM balanced/wubot:1.0.2
```

## Installing `hubot-scripts` to a destination

`make install DEST='${ hubot_dir }/scripts` will copy all the scripts from the `hubot-scripts` directory to your target destination.

## Deploying

This project has been engineered as a proof-of-concept for scalable deployments with AWS's Elastic Beanstalk for Docker. Hence, the easiest way to deploy this will be using AWS's `eb cli` **version 3.0 or higher**.

- Creating an environment (from scratch)
  * `eb create wubot -ip wubot`
  * See [.ebextensions](#.ebextensions) section below

- Deploying an update
  * add a script to the hubot-scripts folder
  * commit and push git repository
  * `eb deploy`

### .ebextensions

#### 01_balanced_specific_aws_vpc.config

#### 02_setup.config
