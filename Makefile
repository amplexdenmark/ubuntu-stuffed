NAME="ubuntu-stuffed"
IMAGE=$(NAME)

all: container

container: .docker
.docker: Dockerfile
	docker build -t $(IMAGE) . && touch .docker

clean2:
	@echo "Removing old containers .."
	docker ps -aq --filter name=$(NAME) | ( x=`cat`; [ -z $x ] || docker rm -v $x )

clean: clean2
	rm .docker

shell: bash
start: bash container

bash: clean2
	@echo "Starting $(NAME) .."
	docker run --name $(NAME) --hostname $(NAME) --rm --volume `pwd`/storage:/amplex \
		--env TERM=$(subst -italic,,$(TERM)) -it --entrypoint=/bin/bash $(IMAGE) -i


stop:
	docker ps -q --filter name=$(NAME) | ( x=`cat`; [ -z $x ] || docker stop $x )

logs:
	docker ps -q --filter name=$(NAME) | ( x=`cat`; [ -z $x ] || docker logs $x )

tail:
	docker ps -q --filter name=$(NAME) | ( x=`cat`; [ -z $x ] || docker logs --follow $x )

.PHONY: container clean clean2 shell bash run stop logs tail
