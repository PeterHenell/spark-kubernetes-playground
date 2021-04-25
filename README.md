# spark-kubernetes-playground
Playground for running spark on kubernetes

Based on 
https://oak-tree.tech/blog/spark-kubernetes-primer

	az login
	az aks create --resource-group kubepoc --name monsunkubernetes --node-count 3  --generate-ssh-keys
	az aks get-credentials --resource-group kubepoc --name monsunkubernetes

https://krew.sigs.k8s.io/docs/user-guide/setup/install/

https://github.com/minio/operator

	kubectl krew update
	kubectl krew install minio


	kubectl create namespace monsun
	kubectl config set-context --current --namespace=monsun

	kubectl minio init
	kubectl minio tenant create monsun-tenant --servers 4 --volumes 16 --capacity 2Gi --namespace monsun --storage-class default

A new Tenant has been created with the following details:
Console Credentials

    Access Key: SDFVHWPPGCFDKHMW
    Secret Key: NEJSFSGIP54KWAIEN1OIBTI11EAOOO41

	←[0m+-------------+-----------------------------+-----------+--------------+--------------+
	| APPLICATION | SERVICE NAME                | NAMESPACE | SERVICE TYPE | SERVICE PORT |
	+-------------+-----------------------------+-----------+--------------+--------------+
	| MinIO       | minio                       | monsun    | ClusterIP    | 443          |
	| Console     | monsun-minio-tenant-console | monsun    | ClusterIP    | 9443         |
	+-------------+-----------------------------+-----------+--------------+--------------+


För att komma åt minio operator admin
	kubectl minio proxy

För att komma åt MinIO Browser.
	kubectl port-forward svc/minio 9000:443

	# om deployat med minio-deployment
	kubectl port-forward svc/object-storage 9000:443
