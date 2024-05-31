# Exports needed
export bps_path=$(<bps_path.txt)
export btk_path=$(<btk_path.txt)
export env_name=$(<env_name.txt)
export btk_project=$(<btk_project.txt)
export path_to_conda=$(<path_conda.txt)
mapfile -t list_subPackages < list_subPackages.txt
mapfile -t list_bps_packages < list_bps_packages.txt
mapfile -t list_conda_install < list_conda_install.txt
mapfile -t list_deps < list_deps.txt

# conda create --name $env_name --file packages.txt
# source $path_to_conda/etc/profile.d/conda.sh
# source $path_to_conda/bin/activate $env_name

# Ipykernel configuration
python -m ipykernel install --user --name=$env_name

# Channels Configuration
mkdir -p $btk_project/bps_channel/noarch
mkdir -p $btk_project/btk_channel/noarch
cp $bps_path/*.tar.bz2 $btk_project/bps_channel/noarch
cp $btk_path/*.tar.bz2 $btk_project/btk_channel/noarch
conda index --verbose $btk_project/bps_channel
conda index --verbose $btk_project/btk_channel
conda config --prepend channels $btk_project/bps_channel
conda config --prepend channels $btk_project/btk_channel

# SubPackages BPS Install
for bpsPackage in "${list_bps_packages[@]}"
do 
    if conda install $btk_project/bps_channel/noarch/$bpsPackage --no-deps; then
        echo "Successfully installed $bpsPackage"
    else
        echo "Error installing $bpsPackage. Check the package or environment setup."
    fi
done

# # SubPackages BTK Install
# for subPackage in "${list_subPackages[@]}"
# do 
#     cd /mnt/c/Projets/btk/libs/$subPackage
#     if python -m pip install --no-build-isolation --no-deps -e .; then
#         echo "Successfully installed $subPackage"
#     else
#         echo "Error installing $subPackage. Check the package or environment setup."
#     fi
# done 


# SubPackages BTK Install
for subPackage in "${list_subPackages[@]}"
do 
    if conda install $btk_project/btk_channel/noarch/$subPackage; then
        echo "Successfully installed $subPackage"
    else
        echo "Error installing $subPackage. Check the package or environment setup."
    fi
done 
