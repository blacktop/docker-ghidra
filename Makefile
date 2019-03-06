REPO=blacktop/docker-ghidra
ORG=blacktop
NAME=ghidra
BUILD ?=$(shell cat LATEST)
LATEST ?=$(shell cat LATEST)


all: build size test

build: ## Build docker image
	docker build -t $(ORG)/$(NAME):$(BUILD) .

.PHONY: size
size: build ## Get built image size
ifeq "$(BUILD)" "$(LATEST)"
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD)| cut -d' ' -f1)-blue/' README.md
	sed -i.bu '/latest/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md
endif
	sed -i.bu '/$(BUILD)/ s/[0-9.]\{3,5\}MB/$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(BUILD))/' README.md

.PHONY: tags
tags:
	docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $(ORG)/$(NAME)

test: ## Test docker image
	echo "not implimented yet"

.PHONY: tar
tar: ## Export tar of docker image
	docker save $(ORG)/$(NAME):$(BUILD) -o $(NAME).tar

.PHONY: push
push: build ## Push docker image to docker registry
	@echo "===> Pushing $(ORG)/$(NAME):$(BUILD) to docker hub..."
	@docker push $(ORG)/$(NAME):$(BUILD)

.PHONY: run
run: stop ## Run docker container
	@docker run --name $(NAME) \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             -e DISPLAY=$(ipconfig getifaddr en0):0 \
             $(ORG)/$(NAME):$(BUILD)

.PHONY: ssh
ssh: ## SSH into docker image
	@docker run --init -it --rm --entrypoint=bash -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$(ipconfig getifaddr en0):0 $(ORG)/$(NAME):$(BUILD)

.PHONY: stop
stop: ## Kill running docker containers
	@docker rm -f $(NAME) || true

.PHONY: stop-all
stop-all: ## Kill ALL running docker containers
	@docker-clean stop

clean: stop-all ## Clean docker image and stop all running containers
	docker rmi $(ORG)/$(NAME):$(BUILD) || true

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help