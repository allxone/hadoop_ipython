# HADOOP_IPYTHON
cp -r -L /etc/hadoop/conf ./hadoop-conf

cp /etc/krb5.conf .

cp /etc/hive/conf/hive-site.xml .

#RUN
8888: IPython Notebook server port
51810: spark.driver.prt
51811: spark.fileserver.port
51812: spark.broadcast.port
51813: spark.replClassServer.port
51814: spark.blockManager.port
hostname: resolved by Spark workers to reach the driver

docker run -d -v /home/core/notebooks:/usr/local/notebooks -p 8888:8888 -p 51810:51810 -p 51811:51811 -p 51812:51812 -p 51813:51813 -p 51814:51814 --hostname=ipython1 --name hadoop_ipython allxone/hadoop_ipython
