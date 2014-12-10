NAME=balanced/wubot
VERSION=`git describe`
CORE_VERSION=HEAD

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
