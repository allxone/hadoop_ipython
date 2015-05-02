# HADOOP_IPYTHON
cp -r /etc/hadoop .

cp /etc/krb5.conf .

#RUN

docker run allxone/hadoop_ipython -p 8888:8888 -e NB_PASSWORD sha1:703304a9dc2f:63feac6936b0f62b9f153a5cff9e57841e8bb9e2
