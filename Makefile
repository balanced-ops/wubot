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
	cp -pr ./$(HUBOT_SCRIPTS_LOC)/* $(DEST)

all: prepare build

prepare:
	git archive -o docker/wubot.tar HEAD
	ansible-galaxy install -r ansible-requirements.yml -p `pwd`/docker --force

build:
	docker build -t $(NAME):$(VERSION) --rm docker

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

test:
	nosetests -sv

push:
	docker push $(NAME):$(VERSION)
