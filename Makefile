SHELL=/bin/bash
DEST?=

HUBOT_SCRIPTS_LOC=hubot-scripts
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
	tar cvf docker/base.tar ansible_hosts \
	                        ansible-requirements.yml \
                          wubot.yml Makefile wubot_overrides.yml

scripts:
	tar cvf docker/scripts.tar -C hubot-scripts .

build:
	docker build -t $(NAME):$(VERSION) --rm docker

secrets:
	ansible-playbook -vc local -i 'localhost,' assemble-secrets.yml

run: pre-run
	docker run --env-file ./secrets.env -d balanced/wubot

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

test:
	nosetests -sv

push:
	docker push $(NAME):$(VERSION)
