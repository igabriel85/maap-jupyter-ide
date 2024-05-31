#!/bin/bash

source /home/user/conda/etc/profile.d/conda.sh
conda activate base

if [ ! -d /projects/envs ];then
  echo "[--] creating conda persistent environments home directory"
  mkdir -p /projects/envs
fi

echo "[--] add /projects/envs to conda envs_dir"
conda config --add envs_dirs /projects/envs

_clone_env=0
if [ -d /projects/envs/pymaap-btk ];then
  if [ ! -d /projects/envs/pymaap-btk/conda-meta ];then
    rm -rf /projects/envs/pymaap-btk
    _clone_env=1
  fi
else
  _clone_env=1
fi

if [ $_clone_env -eq 1 ];then
  echo "[--] clone pymaap into pymaap-btk persistent"
  conda create -y -p /projects/envs/pymaap-btk --clone /home/user/conda/envs/pymaap
fi

echo "[--] changing default conda enviornment to be loaded on terminal"
/usr/bin/sed -i 's/conda .* pymaap/conda activate pymaap-btk/' ~/.bashrc

source  ~/.bashrc

echo "[dd] printing various information"
whoami
which python
echo $PATH
env
echo "[dd] -------------------------------------------------------------"

VERSION=$(jupyter lab --version)
echo "Starting Jupyter Lab"
echo "Jupyter Lab version: $VERSION"
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --ServerApp.token='' --no-browser
