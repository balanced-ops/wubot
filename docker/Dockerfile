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

# base (doesnt change much)
ADD ./base.tar $ANSIBLES/
RUN ansible-galaxy install  \
         -r $ANSIBLES/ansible-requirements.yml  \
         -p $ANSIBLES --force && \
    ansible-playbook -c local \
                      -i $ANSIBLES/ansible_hosts \
                      -v $ANSIBLES/base.yml

# changes onwards
ADD ./scripts.tar $ANSIBLES/
# temporarily do this while configuring wubot..
RUN apt-get install -y --no-install-recommends python-boto && \
    ln -s $ANSIBLES/ansible-hubot/lookup_plugins $ANSIBLES/lookup_plugins && \
    ansible-playbook -v -c local $ANSIBLES/wubot.yml

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup runit
CMD ["/sbin/my_init"]
