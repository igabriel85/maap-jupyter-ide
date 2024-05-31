#!/bin/bash

source /home/user/conda/etc/profile.d/conda.sh
conda activate pymaap

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

VERSION=$(jupyter lab --version)
echo "Starting Jupyter Lab"
echo "Jupyter Lab version: $VERSION"
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --ServerApp.token='' --no-browser