# Define environment variables with accounts and auth parameters
export SPARK_NAMESPACE=monsun
export SA=spark-minion
export K8S_CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export K8S_TOKEN=/var/run/secrets/kubernetes.io/serviceaccount/token

# Docker runtime image
export DOCKER_IMAGE=peterhenell/spark-kubernetes-playground:base
export SPARK_DRIVER_NAME=spark-test1-pi

# The command below submits the job to the cluster. It will deploy in "cluster" mode and references the spark-examples JAR from the container image. We tell Spark which program within the JAR to execute by defining a --class option. In this case, we wish to run org.apache.spark.examples.SparkPi.

# spark-submit command
/opt/spark/bin/spark-submit --name sparkpi-test1 \
   --master k8s://https://kubernetes.default:443 \
  --deploy-mode cluster  \
  --class org.apache.spark.examples.SparkPi  \
  --conf spark.kubernetes.driver.pod.name=$SPARK_DRIVER_NAME  \
  --conf spark.kubernetes.authenticate.subdmission.caCertFile=$K8S_CACERT  \
  --conf spark.kubernetes.authenticate.submission.oauthTokenFile=$K8S_TOKEN  \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=$SA  \
  --conf spark.kubernetes.namespace=$SPARK_NAMESPACE  \
  --conf spark.executor.instances=2  \
  --conf spark.kubernetes.container.image=$DOCKER_IMAGE  \
  --conf spark.kubernetes.container.image.pullPolicy=Always \
  local:///opt/spark/examples/jars/spark-examples_2.11-2.4.7.jar 1000

