def get_spark(nameApp='nameApp', queueName='nameQueue', numExecutors='4', executorCores='1', executorMemory='2G'):

    import os
    import sys
    import glob

    SPARK_HOME = os.environ['SPARK_HOME']
    SPARK_DRIVER_PORT = os.environ['SPARK_DRIVER_PORT']
    SPARK_REPL_PORT = os.environ['SPARK_REPL_PORT']
    SPARK_FILESERVER_PORT = os.environ['SPARK_FILESERVER_PORT']
    SPARK_BROADCAST_PORT = os.environ['SPARK_BROADCAST_PORT']
    SPARK_BLOCKMGR_PORT = os.environ['SPARK_BLOCKMGR_PORT']

    sys.path.insert(0, os.path.join(SPARK_HOME, 'python'))

    py4j = glob.glob(SPARK_HOME + '/python/lib/' + 'py4j-*-src.zip')[0].split("/")[-1]
    sys.path.insert(0, os.path.join(SPARK_HOME, 'python/lib/' + py4j))
    
    from pyspark import SparkContext
    from pyspark import SparkConf

    conf = SparkConf()\
        .setAppName(nameApp)\
        .setMaster('yarn-client')\
        .set("spark.yarn.queue", queueName)\
        .set("spark.executor.instances", numExecutors)\
        .set("spark.executor.cores", executorCores)\
        .set("spark.executor.memory", executorMemory)\
        .set("spark.driver.port", SPARK_DRIVER_PORT)\
        .set("spark.replClassServer.port", SPARK_REPL_PORT)\
        .set("spark.fileserver.port", SPARK_FILESERVER_PORT)\
        .set("spark.broadcast.port", SPARK_BROADCAST_PORT)\
        .set("spark.blockManager.port", SPARK_BLOCKMGR_PORT)
    sc = SparkContext(conf=conf)
    
    return sc

def auth(user, realm):

    from subprocess import Popen, PIPE
    import getpass

    pwd = getpass.getpass()

    kinit = '/usr/bin/kinit'
    kinit_args = [kinit, '%s@%s' % (user, realm)]
    kinit = Popen(kinit_args, stdin=PIPE, stdout=PIPE, stderr=PIPE)
    kinit.stdin.write('%s\n' % pwd)
    kinit.wait()
