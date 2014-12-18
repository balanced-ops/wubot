SHELL=/bin/bash
DEST?=

HUBOT_SCRIPTS_LOC=hubot-scripts
NAME=balanced/wubot
VERSION=`git describe`
CORE_VERSION=HEAD


.PHONY: all install secrets patch-eb-run guard-%

guard-%:
	@ if [ "${${*}}" == "" ]; then    \
		echo "$* is required to be set!"; \
		echo "Example: make install $*='\"/home/some/path/here\"'"; \
		exit 1; \
	fi

# Install Hubot Scripts

install: guard-DEST
	if [ ! -d "$(DEST)" ]; then mkdir -p "$(DEST)"; fi
	cp -pr ./$(HUBOT_SCRIPTS_LOC)/* $(DEST)

# docker build
all: base scripts

base:
	env COPY_EXTENDED_ATTRIBUTES_DISABLE=true COPYFILE_DISABLE=true \
		tar cvf docker/base.tar --exclude '\._*' \
			-C docker/build				\
			ansible_hosts				\
			ansible-requirements.yml	\
			wubot.yml					\
			wubot_overrides.yml

scripts:
	env COPY_EXTENDED_ATTRIBUTES_DISABLE=true COPYFILE_DISABLE=true \
		tar cvf docker/scripts.tar --exclude '\._*' \
			-C hubot-scripts .

# docker commands
build:
	docker build -t $(NAME):$(VERSION) --rm docker

run: secrets
	docker run --env-file ./secrets.env -d balanced/wubot

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

# deploy commands
ifeq ("$(strip $(DEST))", "")
secrets:
	cd deploy && \
		ansible-playbook -c local -i 'localhost,' assemble-secrets.yml \
		-e secrets_dir="."
else
secrets:
	cd deploy && \
		ansible-playbook -c local -i 'localhost,' assemble-secrets.yml \
		-e secrets_dir="$(DEST)"
endif

patch-eb-run:
	cd deploy && ansible-playbook -vc local -i 'localhost,' patch-eb-scripts.yml
