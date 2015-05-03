FROM allxone/hadoop_client
MAINTAINER allxone@hotmail.com

# Continuum Anaconda
# source: https://registry.hub.docker.com/u/continuumio/anaconda/dockerfile/
RUN wget --quiet https://repo.continuum.io/archive/Anaconda-2.2.0-Linux-x86_64.sh && \
    /bin/bash /Anaconda-2.2.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda-2.2.0-Linux-x86_64.sh && \
    /opt/conda/bin/conda install --yes conda==3.10.1
ENV PATH /opt/conda/bin:$PATH

# Prerequisites
RUN yum -y install libXext libSM libXrender && \
    yum clean all

# Load Kerberos
ADD krb5.conf /etc/krb5.conf

# Load Hadoop Config
ADD hadoop /etc/hadoop/
ADD hive-site.xml $SPARK_HOME/conf/hive-site.xml
ADD hosts_append /root/hosts_append

# iPython Notebook
ADD notebook.sh /
RUN mkdir -p /usr/local/notebooks && \
    ipython profile create hadoop_notebook && \
    cd /usr/local/notebooks && \
    git clone https://github.com/agconti/kaggle-titanic.git && \
    cat /root/hosts_append >> /etc/hosts && \
    chmod u+x /notebook.sh
ADD ipython_notebook_config.py /root/.ipython/profile_hadoop_notebook/ipython_notebook_config.py
ADD spark_utils.py /opt/conda/lib/python2.7/site-packages/spark_utils.py
ENV PEM_FILE /key.pem

EXPOSE 8888

# Default notebook pwd = password (hashed from ipython: from IPython.lib import passwd; passwd() )
ENV NB_PASSWORD sha1:ecc7bd1b8e2a:b9464f6ed664d7c81503ad877325dab6f2d63c13

CMD ["/notebook.sh"]
