FROM allxone/hadoop_client
MAINTAINER allxone@hotmail.com

# Default notebook password (hashed from ipython: from IPython.lib import passwd; passwd() )
ENV NB_PASSWORD sha1:703304a9dc2f:63feac6936b0f62b9f153a5cff9e57841e8bb9e2

# Prerequisites
RUN yum -y install krb5-workstation && \
    yum clean all

# Continuum Anaconda
# source: https://registry.hub.docker.com/u/continuumio/anaconda/dockerfile/
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda-2.2.0-Linux-x86_64.sh && \
    /bin/bash /Anaconda-2.2.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda-2.2.0-Linux-x86_64.sh && \
    /opt/conda/bin/conda install --yes conda==3.10.1
ENV PATH /opt/conda/bin:$PATH

# Load Kerberos
ADD krb5.conf /etc/krb5.conf

# Load Hadoop Config
ADD hadoop /etc/hadoop
ADD hosts /root/hosts_append

# iPython Notebook (default pwd: password)
RUN mkdir -p /usr/local/notebooks && \
    ipython profile create hadoop_notebook && \
    cat /root/hosts_append >> /etc/hosts
ADD ipython_notebook_config.py /root/.ipython/profile_hadoop_notebook/ipython_notebook_config.py
ADD spark_utils.py /root/.ipython/profile_hadoop_notebook/spark_utils.py
EXPOSE 8888

CMD notebook --profile hadoop_notebook --NotebookApp.password=u'$NB_PASSWORD'
ENTRYPOINT ipython
