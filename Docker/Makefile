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

build-base: ## Build base image, used for workers and base for the driver.
	docker build -f Dockerfile.base -t $(BASE-IMAGE) .

push-base: build-base ## Push the contaimer image to a public registry
	docker push $(BASE-IMAGE)

build-driver: build-base ## Build and tag the driver image
	docker build -f Dockerfile.driver -t $(DRIVER-IMAGE) .

push-driver: build-driver ## Push the contaimer image to a public registry
	docker push $(DRIVER-IMAGE)

build-jupyter: build-driver ## Build and tag image for Jupyter
	docker build -f Dockerfile.jupyter -t $(JUPYTER-IMAGE) .

push-jupyter: build-jupyter ## Push jupyter image
	docker push $(JUPYTER-IMAGE)

push: push-base push-driver push-jupyter ## Push Base, driver and Jupyter

minikube-start: ## Create kubernetes kluster in minikube
	minikube start --driver=docker

minikube-delete: ## Deletes kubernetes kluster in minikube
	minikube delete

az-login: ## login to azure before running any azure commands.
	$(az) login

az-start: az-login ## Create kubernetes cluster in Azure
	$(az) aks create --resource-group etltodf --name monsunkubernetes --node-count 3  --generate-ssh-keys
	$(az) aks get-credentials --resource-group etltodf --name monsunkubernetes

az-delete: az-login ## Deletes cluster in Azure
	$(az) aks delete --resource-group etltodf --name monsunkubernetes


configure-kubernetes: ## When kubectl context have been set to correct cluster, this will configure that cluster	
	# Create $(SA-SPARK-DRIVER) service account
	kubectl create serviceaccount $(SA-SPARK-DRIVER)

	# Create a cluster and namespace "role-binding" to grant the account administrative privileges
	kubectl create rolebinding $(SA-SPARK-DRIVER)-rb --clusterrole=cluster-admin --serviceaccount=default:$(SA-SPARK-DRIVER)

	# Create Spark executor account
	kubectl create serviceaccount spark-minion

	# Create rolebinding to offer "edit" privileges
	kubectl create rolebinding spark-minion-rb --clusterrole=edit --serviceaccount=default:spark-minion

expose: ## Expose the jump pod using a headless service
	kubectl expose pod $(SPARK_DRIVER_NAME) --port=$(SPARK_DRIVER_PORT) --type=ClusterIP --cluster-ip=None

expose-rem: ## Remove exposure to jump pod
	kubectl delete svc $(SPARK_DRIVER_NAME)

port-forward: ## Forward a port in the local environment to the pod to test the runtime
	# this one creates a service which needs to be deleted if running the command again.
	# keeping this here mostly for remembering..
	kubectl expose pod jupyter-test-pod --type=ClusterIP --cluster-ip=None
	kubectl port-forward pod/jupyter-test-pod 8888:8888

jump: ## Create a jump pod using the Spark driver container and service account
	kubectl run $(SPARK_DRIVER_NAME) --generator=run-pod/v1 -it --rm=true \
	--image=$(DRIVER-IMAGE) \
	--serviceaccount=$(SA-SPARK-DRIVER) \
	--image-pull-policy Always \
	--command -- /bin/bash

jupyter: ## Start an instance of Jupyter container in Kubernetes
	kubectl run jupyter-test-pod --generator=run-pod/v1 -it --rm=true \
	--image=$(JUPYTER-IMAGE) \
	--serviceaccount=spark-driver \
	--command -- jupyter lab --ip 0.0.0.0