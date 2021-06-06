# spark-kubernetes-playground
Playground for running spark on kubernetes

Based on 
https://oak-tree.tech/blog/spark-kubernetes-primer


https://krew.sigs.k8s.io/docs/user-guide/setup/install/

https://github.com/minio/operator

	kubectl krew update
	kubectl krew install minio


	kubectl create namespace monsun
	kubectl config set-context --current --namespace=monsun

	kubectl minio init
	kubectl minio tenant create monsun-tenant --servers 4 --volumes 16 --capacity 2Gi --namespace monsun --storage-class default

För att följa installationen som minio operator utför
	 
	 kubectl get tenants.minio.min.io

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
	# https://127.0.0.1:9000/minio/login

Jupyter
	make jupyter
	# in second terminal run
	kubectl port-forward pod/jupyter-test-pod 8800:8888
	# in same second terminal
	kubectl logs jupyter-test-pod

	# to enable executors to report progres, create a service on the jupyter pod
	kubectl expose pod jupyter-test-pod --type=ClusterIP --cluster-ip=None
	


TODO

	1: Done: Installera minio operator och tenant
	2: Done: verifiera att spark kan läsa från minio
	3: Verifiera att spark can read from OUR minio
		SSL is the problem
		can disable cert check, for now:
		spark-shell --conf 'spark.executor.extraJavaOptions=-Dcom.amazonaws.sdk.disableCertChecking=true' --conf 'spar
k.driver.extraJavaOptions=-Dcom.amazonaws.sdk.disableCertChecking=true'

	Maybe we can use self signed cert:

	https://stackoverflow.com/questions/61301704/how-to-run-apache-spark-with-s3-minio-secured-with-self-signed-certificate

	keytool -import -trustcacerts -alias certalias \
-noprompt -file /path/to/cert.crt \
-keystore $JAVA_HOME/jre/lib/security/cacerts \
-storepass changeit