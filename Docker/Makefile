# import environment config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= env.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help 

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build-base: ## Build base image, used for workers and base for the driver.
	docker build -f Dockerfile.base -t peterhenell/spark-kubernetes-playground:base .

push-base: build-base ## Push the contaimer image to a public registry
	docker push peterhenell/spark-kubernetes-playground:base

build-driver: build-base ## Build and tag the driver image
	docker build -f Dockerfile.driver -t peterhenell/spark-kubernetes-playground:driver .

push-driver: build-driver ## Push the contaimer image to a public registry
	docker push peterhenell/spark-kubernetes-playground:driver

