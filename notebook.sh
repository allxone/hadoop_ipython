#!/bin/bash
#source: https://github.com/ipython/docker-notebook/blob/master/notebook/notebook.sh

# Strict mode
set -euo pipefail
IFS=$'\n\t' 

# Create a self signed certificate for the user if one doesn't exist
if [ ! -f $PEM_FILE ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $PEM_FILE -out $PEM_FILE \
    -subj "/C=XX/ST=XX/L=XX/O=dockergenerated/CN=dockergenerated"
fi

CERTFILE_OPTION="--certfile=$PEM_FILE"

ipython notebook --no-browser --port 8888 --ip=* $CERTFILE_OPTION --NotebookApp.password="$NB_PASSWORD" --profile hadoop_notebook
