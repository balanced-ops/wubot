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
       software-properties-common \
       build-essential && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
       ansible \
       python-apt \
       curl \
       git-core \
       python-setuptools  && \
    # Clean up APT when done.
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# base (doesn't change much)
ADD ./base.tar $ANSIBLES/
RUN ansible-galaxy install  \
         -r $ANSIBLES/ansible-requirements.yml   \
         -p $ANSIBLES --force && \
    ansible-playbook -c local \
                      -i $ANSIBLES/ansible_hosts \
                      -v $ANSIBLES/wubot.yml  && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# scripts (changes more often)
ADD ./scripts.tar /opt/hubot/scripts

VOLUME ["/var/log"]

# default, run runit and various goodies
CMD ["/sbin/my_init"]

# Expose ports(8080 for hubot)
EXPOSE 8080
