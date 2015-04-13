## Docker Container with CDH-5.3.0 & Apache Spark-1.3.1

### Installed software;

* cdh-5.3.0
   * hive-0.13.0
   * hadoop-2.5.0
* spark-1.3.1
* thrift-0.9.0
* protobuf-2.6.0
* maven-3.2.5

By default, `SPARK_HOME=/usr/lib/spark/1.3.1` and Apache Spark 1.3.1 is built with support for `hive` (Spark SQL).

### How to use?

```bash
docker pull ypandit/cdh-spark
docker run -td ypandit/cdh-spark
```