# import environment config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= env.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))
az = /cygdrive/c/Program\ Files\ \(x86\)/Microsoft\ SDKs/Azure/CLI2/wbin/az.cmd

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help 

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build-executor: ## Build base image, used for workers and base for the driver.
	docker build -f Dockerfile.executor -t $(EXECUTOR-IMAGE) .

push-executor: build-executor ## Push the contaimer image to a public registry
	docker push $(EXECUTOR-IMAGE)

build-driver: build-executor ## Build and tag the driver image
	docker build -f Dockerfile.driver -t $(DRIVER-IMAGE) .

push-driver: build-driver ## Push the contaimer image to a public registry
	docker push $(DRIVER-IMAGE)

build-jupyter: build-driver ## Build and tag image for Jupyter
	docker build -f Dockerfile.jupyter -t $(JUPYTER-IMAGE) .

push-jupyter: build-jupyter ## Push jupyter image
	docker push $(JUPYTER-IMAGE)

build: build-executor build-driver build-jupyter

push: push-executor push-driver push-jupyter