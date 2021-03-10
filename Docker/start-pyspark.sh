# Define environment variables with accounts and auth parameters
export SPARK_NAMESPACE=default
export SA=spark-minion
export K8S_CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export K8S_TOKEN=/var/run/secrets/kubernetes.io/serviceaccount/token

# Docker runtime image
export DOCKER_IMAGE=peterhenell/spark-kubernetes-playground:base
export SPARK_DRIVER_NAME=spark-test-pod
export SPARK_DRIVER_PORT=20020

# Start pyspark
/opt/spark/bin/pyspark --name pyspark-test1 \
   --master k8s://https://kubernetes.default:443 \
  --deploy-mode client  \
  --conf spark.kubernetes.driver.pod.name=$SPARK_DRIVER_NAME  \
  --conf spark.kubernetes.authenticate.subdmission.caCertFile=$K8S_CACERT  \
  --conf spark.kubernetes.authenticate.submission.oauthTokenFile=$K8S_TOKEN  \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=$SA  \
  --conf spark.kubernetes.namespace=$SPARK_NAMESPACE  \
  --conf spark.executor.instances=2  \
  --conf spark.kubernetes.container.image=$DOCKER_IMAGE  \
  --conf spark.kubernetes.container.image.pullPolicy=Always \
  --conf spark.driver.host=$HOSTNAME.$SPARK_NAMESPACE \
  --conf spark.driver.port=$SPARK_DRIVER_PORT