# HADOOP_IPYTHON
cp -r -L /etc/hadoop/conf ./hadoop-conf

cp /etc/krb5.conf .

cp /etc/hive/conf/hive-site.xml .

#RUN

docker run -p 8888:8888 --name hadoop_ipython --rm allxone/hadoop_ipython
