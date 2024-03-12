#!/bin/bash
# Ask the user for the path of the project
echo "Hello, please enter the path of the sharedata properties"
echo -n "The path of the sharedata.properties of your project. It should be in /projects/THE_NAME_YOU_MUST_CHANGE/conf/sharedata.properties :"
export propertiesPath=$PROJECT_SOURCE/conf/sharedata.properties
read propertiesPath
echo "===> The path is : " $propertiesPath

python $HOME/ingestData.py  $propertiesPath
