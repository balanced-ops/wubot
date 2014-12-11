SHELL=/bin/bash
DEST?=

HUBOT_SCRIPTS_LOC=scripts
NAME=balanced/wubot
VERSION=`git describe`
CORE_VERSION=HEAD


.PHONY: all install guard-%


guard-%:
	@ if [ "${${*}}" == "" ]; then    \
		echo "$* is required to be set!"; \
		echo "Example: make install $*='\"/home/some/path/here\"'"; \
		exit 1; \
	fi

install: guard-DEST
	if [ ! -d "$(DEST)" ]; then mkdir -p "$(DEST)"; fi
	cp -pr ./$(HUBOT_SCRIPTS_LOC)/* $(DEST)

all: prepare build

base:
	tar cvf docker/base.tar  ansible_hosts            \
                             ansible-requirements.yml \
                             base.yml

scripts:
	tar cvf docker/scripts.tar hubot-scripts wubot.yml Makefile

build:
	docker build -t $(NAME):$(VERSION) --rm docker

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

test:
	nosetests -sv

push:
	docker push $(NAME):$(VERSION)
