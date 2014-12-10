FROM phusion/baseimage:0.9.15
MAINTAINER mahmoud@balancedpayments.com

# Set correct environment variables.
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV ANSIBLES /ansibles

# set sane locale
RUN locale-gen en_US.UTF-8

# Install updates
RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends \
       python-software-properties \
       software-properties-common \
       build-essential && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y \
       ansible \
       python-apt \
       curl \
       git-core

ADD ./ansible_hosts /etc/ansible/hosts

# the following are just roles, we're just running different playbooks
# that are including these roles.

# see here for reference:
# - https://github.com/cloudisland/minecraft/blob/master/Dockerfile
# - https://github.com/romeOz/vagrant-rock-cache/blob/master/Dockerfile

# Install hubot (inlined task.yml for max cache)
ADD ./ansible-hubot $ANSIBLES/ansible-hubot
ADD ./wubot.yml $ANSIBLES/wubot.yml
RUN ansible-playbook -v -c local $ANSIBLES/wubot.yml -t user
RUN ansible-playbook -v -c local $ANSIBLES/wubot.yml -t node
RUN ansible-playbook -v -c local $ANSIBLES/wubot.yml -t hubot
RUN ansible-playbook -v -c local $ANSIBLES/wubot.yml -t service

# TODO: move into wubot repo..
RUN ansible-playbook -v -c local $ANSIBLES/wubot.yml -t scripts

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup runit
CMD ["/sbin/my_init"]
