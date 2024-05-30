#!/bin/bash

export PATH=/home/user/conda/envs/pymaap/bin:$PATH

# Ensure $HOME exists when starting
if [ ! -d "${HOME}" ]; then
  mkdir -p "${HOME}"
fi

# Add current (arbitrary) user to /etc/passwd and /etc/group
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:$(id -u):" >> /etc/group
  fi
fi

whoami
which python
echo $PATH

# pack old env

DIR = $PROJECT_SOURCE/envs/pymaap_btk/
# Check if directory exists
if [ -d "$DIR" ]; then
    source $PROJECT_SOURCE/envs/pymaap_btk/bin/activate
    $PROJECT_SOURCE/envs/pymaap_btk/bin/conda-unpack
else
    echo "pymaap_btk env does not exist. Creating new env."
    conda-pack -n base -o /tmp/pymaap_btk.tar
    mkdir -p $PROJECT_SOURCE/envs/pymaap_btk/
    mv /tmp/pymaap_btk.tar $PROJECT_SOURCE/envs/pymaap_btk/pymaap.tar
    # untar env
    cd $PROJECT_SOURCE/envs/pymaap_btk/
    tar xvf pymaap.tar
    rm pymaap.tar
    source $PROJECT_SOURCE/envs/pymaap_btk/bin/activate
    $PROJECT_SOURCE/envs/pymaap_btk/bin/conda-unpackXW
fi




VERSION=$(jupyter lab --version)
echo "Starting Jupyter Lab"
echo "Jupyter Lab version: $VERSION"
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --ServerApp.token='' --no-browser