// Tested working with public https://play.min.io:9000 Q3AM3UQ867SPQQA43P2F zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG
sc.hadoopConfiguration.set("fs.s3a.endpoint", "https://play.min.io:9000")
sc.hadoopConfiguration.set("fs.s3a.access.key", "Q3AM3UQ867SPQQA43P2F")
sc.hadoopConfiguration.set("fs.s3a.secret.key", "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG")
sc.hadoopConfiguration.set("fs.s3a.path.style.access", "true")
sc.hadoopConfiguration.set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")

// might need this for our installation to begin with
sc.hadoopConfiguration.set("fs.s3a.connection.ssl.enabled", "false")

// for all options (lol)
// https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/core-default.xml

val myRDD = sc.textFile("s3a://documents/Notebook-demo.txt")
myRDD.count

// for own minio installation
sc.hadoopConfiguration.set("fs.s3a.endpoint", "https://minio")
sc.hadoopConfiguration.set("fs.s3a.access.key", "YOURCONSOLEACCESS")
sc.hadoopConfiguration.set("fs.s3a.secret.key", "YOURCONSOLESECRET")
sc.hadoopConfiguration.set("fs.s3a.path.style.access", "true")
sc.hadoopConfiguration.set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")

val myRDD = sc.textFile("s3a://test/swagger.yaml")
myRDD.count