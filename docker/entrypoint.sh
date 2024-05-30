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


# if not in che, env var is not set
VAR_NAME="PROJECT_SOURCE"
DEFAULT_VALUE="/projects/maap-jupyter"
# Check if the environment variable is defined
if [ -z "${!VAR_NAME}" ]; then
    # Set the environment variable if it is not defined
    export $VAR_NAME="$DEFAULT_VALUE"
    echo "$VAR_NAME was not set. It has been set to '$DEFAULT_VALUE'."
else
    echo "$VAR_NAME is already set to '${!VAR_NAME}'."
fi

DIR="$PROJECT_SOURCE/envs/pymaap_btk/"
# Check if directory exists
if [ -d "$DIR" ]; then
    source $PROJECT_SOURCE/envs/pymaap_btk/bin/activate
    $PROJECT_SOURCE/envs/pymaap_btk/bin/conda-unpack
else
    echo "pymaap_btk env does not exist. Creating new env."
    conda-pack -p $CONDA_DIR/envs/pymaap -o /tmp/pymaap_btk.tar
    mkdir -p $PROJECT_SOURCE/envs/pymaap_btk/
    mv /tmp/pymaap_btk.tar $PROJECT_SOURCE/envs/pymaap_btk/pymaap.tar
    # untar env
    cd $PROJECT_SOURCE/envs/pymaap_btk/
    tar xvf pymaap.tar
    rm pymaap.tar
    source $PROJECT_SOURCE/envs/pymaap_btk/bin/activate
    $PROJECT_SOURCE/envs/pymaap_btk/bin/conda-unpack
fi




VERSION=$(jupyter lab --version)
echo "Starting Jupyter Lab"
echo "Jupyter Lab version: $VERSION"
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --ServerApp.token='' --no-browser