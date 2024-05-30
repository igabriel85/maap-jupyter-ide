export env_name=$(<env_name.txt)
export btk_project=$(<btk_project.txt)
mapfile -t list_conda_install < list_conda_install.txt
mapfile -t list_deps < list_deps.txt

for dep in "${list_conda_install[@]}"
do
    if [[ "$dep" == "conda-build<24" ]]; then
        conda install -y "$dep"
        echo "Successfully installed"
        mkdir -p local_channel/noarch
        #conda install -c conda-forge conda-verify -y
        #conda install -c conda-forge mamba -y
        #conda install -c conda-forge 'libarchive=3.7.2' -y
        #conda install -c conda-forge cartopy -y
        #conda install -c conda-forge 'gdal<3.6,>=3.5' -y
        conda install -c conda-forge conda-verify mamba 'libarchive=3.7.2' cartopy 'gdal<3.6,>=3.5' -y
        #conda install 'ruamel.yaml<0.18.0' -y
        #conda install 'opencv-python-headless<4.7' -y
        #conda install 'numpy<1.24,>=1.20' -y
        #conda install 'libtiff=4.4' -y
        #conda install 'virtualenv>=20.14.1' -y
        #conda install 'xmlschema<2.5' -y
        conda install 'ruamel.yaml<0.18.0' 'opencv-python-headless<4.7' 'numpy<1.24,>=1.20' 'libtiff=4.4' 'virtualenv>=20.14.1' 'xmlschema<2.5' -y
    else
        if conda install -y "$dep"; then
            echo "Successfully installed"
        else
            echo "channels not configured"
        fi
        echo "Error installing"
    fi
done

# Packages Install
ldt=()
for dep in "${list_deps[@]}"
do
    #if conda install "$dep" -y ; then
    #    echo "Successfully installed $dep"
    #else
    #    echo "Error installing $dep"
    #fi
    ldt+=("$dep")
done 

conda install ${ldt[@]} -y
conda list --explicit > packages.txt
