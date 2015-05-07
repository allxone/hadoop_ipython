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
RUN (yum -y install libXext libSM libXrender || yum -y install libXext libSM libXrender) && \
    yum clean all

# Load Kerberos config
ADD krb5.conf /etc/krb5.conf

### IPython Notebook
# Default notebook pwd = password (hashed from ipython: from IPython.lib import passwd; passwd() )
ENV NB_PASSWORD sha1:ecc7bd1b8e2a:b9464f6ed664d7c81503ad877325dab6f2d63c13
ENV NB_USER cdhadmin
ENV USE_HTTP 0
ENV PEM_FILE /home/$NB_USER/key.pem
ENV NB_LIBRARY /usr/local/notebooks
ENV SPARK_DRIVER_PORT 51810
ENV SPARK_REPL_PORT 51813
ENV SPARK_FILESERVER_PORT 51811
ENV SPARK_BROADCAST_PORT 51812
ENV SPARK_BLOCKMGR_PORT 51814

ADD notebook.sh /
ADD hosts_append /root/hosts_append

RUN useradd -ms /bin/bash $NB_USER \
    && ipython profile create hadoop_notebook \
    && cd && cp -R .bash_profile .bashrc .ipython /home/$NB_USER \
    && chown -R $NB_USER:$NB_USER /home/$NB_USER \
    && mkdir -p $NB_LIBRARY \
    && cd $NB_LIBRARY \
    && git clone https://github.com/agconti/kaggle-titanic.git \
    && chown -R $NB_USER:$NB_USER $NB_LIBRARY \
    && rm -rf /etc/hadoop/conf \
    && cat /root/hosts_append >> /etc/hosts \
    && chmod u+x /notebook.sh
ADD ipython_notebook_config.py /home/$NB_USER/.ipython/profile_hadoop_notebook/ipython_notebook_config.py
ADD spark_utils.py /opt/conda/lib/python2.7/site-packages/spark_utils.py

# Load Hadoop Config
ADD hadoop-conf /etc/hadoop/conf/
ADD hive-site.xml $SPARK_HOME/conf/hive-site.xml

EXPOSE $SPARK_DRIVER_PORT $SPARK_REPL_PORT $SPARK_FILESERVER_PORT $SPARK_BROADCAST_PORT $SPARK_BLOCKMGR_PORT
VOLUME $NB_LIBRARY

USER $NB_USER
WORKDIR $NB_LIBRARY
CMD ["/notebook.sh"]
