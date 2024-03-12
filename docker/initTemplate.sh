#!/bin/bash
# My first script

#Initialisation of variables
pwd=`pwd`

templateInitialisation() {

	echo "#### Project initialisation is started in the folder $pwd ####"	
	unzip $HOME/Project_template.zip -d $pwd
	mv $pwd/Project_template/* $PROJECT_SOURCE
	rm -rf $pwd/Project_template
	rm $pwd/Dockerfile
}

#Invokation of the function
templateInitialisation
