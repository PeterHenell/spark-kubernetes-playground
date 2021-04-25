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

build: build-executor build-driver build-jupyter ## builds all images

push: push-executor push-driver push-jupyter ## pushes all images to docker.io

az-login: ## login to azure before running any azure commands.
	$(az) login

az-start-cluster: az-login ## Create kubernetes cluster in Azure
	$(az) aks create --resource-group etltodf --name monsunkubernetes --node-count 5  --generate-ssh-keys

az-getcredentials: ## Configure kubectl context to point to the kubernetes cluster, overwriting existing configuration for clusters by same name
	$(az) aks get-credentials --resource-group etltodf --name monsunkubernetes --overwrite-existing

kube-create-namespace: ## Creates the monsun namespace in the kubernetes cluster, sets the current context to the new namespace
	kubectl create namespace monsun
	kubectl config set-context --current --namespace=monsun

kube-config: ## When kubectl context have been set to correct cluster, this will configure that cluster	
	# Create $(SA-SPARK-DRIVER) service account
	kubectl create serviceaccount $(SA-SPARK-DRIVER)

	# Create a cluster and namespace "role-binding" to grant the account administrative privileges
	kubectl create rolebinding $(SA-SPARK-DRIVER)-monsun-rb --clusterrole=cluster-admin --serviceaccount=monsun:$(SA-SPARK-DRIVER)
	kubectl create rolebinding $(SA-SPARK-DRIVER)-default-rb --clusterrole=cluster-admin --serviceaccount=default:$(SA-SPARK-DRIVER)

	# Create Spark executor account
	kubectl create serviceaccount spark-minion

	# Create rolebinding to offer "edit" privileges
	kubectl create rolebinding spark-minion-rb --clusterrole=edit --serviceaccount=monsun:spark-minion

minio-operator: ## Install the Minio operator to the cluster. Requires krew on local machine and to have executed: kubectl krew install minio
	kubectl minio init

minio-tenant: minio-operator ## Create the minio tenant. Will take a few minutes at least
	kubectl minio tenant create monsun-tenant --servers 4 --volumes 16 --capacity 2Gi --namespace monsun --storage-class default

minio: minio-operator minio-tenant ## installs operator and the tenant

az-create: az-start-cluster az-getcredentials kube-create-namespace kube-config ## Creates cluster and configures namespace, service account etc