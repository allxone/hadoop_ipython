# HADOOP_IPYTHON
cp -r -L /etc/hadoop/conf ./hadoop-conf

cp /etc/krb5.conf .

cp /etc/hive/conf/hive-site.xml .

#RUN
# 8888: IPython Notebook server port
# 8887: Spark Driver fixed port (spark.driver.port)
# 8886: Spark REPL port (using pyspark shell, spark.replClassServer.port)
# hostname: need to be resolved by Spark Workers to permit them reach the driver
docker run -p 8888:8888 -p 8887:8887 -p 8886:8886 --hostname=ipython1 --name hadoop_ipython --rm allxone/hadoop_ipython
