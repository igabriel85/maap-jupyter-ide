# MAAP Jupyter IDE container
This repository contains the Dockerfile and associated files for building a Docker container for the MAAP Eclipse Che workspace custom Jupyter Lab IDE.
It is based on the Universal developer image UBI8 provided by Red Hat.
Workspace is running on Python 3.10.13 and conda environment.

# Building the Docker container
To build the Docker container, run the following command in the root directory of the repository:
```bash
docker build --no-cache -t maap-jupyter-ide .
```

Once the build is complete, you can run the container with the following command:
```bash
docker run -it -p 8080:8080 maap-jupyter-ide
```

Or you can upload it ot a DOcker registry such as Quay.io:
```bash
docker tag maap-jupyter-ide quay.io/maap/maap-jupyter-ide
docker push quay.io/maap/maap-jupyter-ide
```

We should note that a Conda environment named `pymaap` will be created and activated once the container is started. This environment is based on Python 3.10.13 and contains the following packages:

  - folium=0.15.1
  - gitpython=3.1.40
  - ipyleaflet=0.18.1
  - jupyterlab=3.6.3
  - jupyterlab-git=0.34.2
  - jupyter-packaging=0.12.3
  - jupyterlab_widgets=3.0.7
  - nodejs=18.15.0
  - plotly=5.18.0
  - plotnine=0.12.2
  - plotnine=0.12.2
  - awscli=2.14.1
  - backoff=2.2.1
  - basemap=1.3.7
  - boto3=1.34.15
  - cython=3.0.7
  - earthengine-api=0.1.384
  - gdal=3.7.0
  - geocube=0.4.2
  - geopandas=0.14.2
  - h5py=3.9.0
  - hdf5=1.14.0
  - httpx=0.26.0
  - mapclassify=2.6.1
  - matplotlib=3.7.3
  - mizani=0.10.0
  - mpl-scatter-density=0.7
  - numba=0.58.1
  - numpy=1.26.3
  - pandas=2.1.4
  - pandarallel=1.6.5
  - pycurl=7.45.1
  - pygeos=0.14
  - pyogrio=0.6.0
  - pyproj=3.5.0
  - pystac-client=0.7.5
  - python=3.10.13
  - rasterio=1.3.7
  - rasterstats=0.19.0
  - requests=2.31.0
  - rio-cogeo=5.1.1
  - rtree=1.1.0
  - s3fs=0.4.2
  - scikit-learn=1.3.2
  - scipy=1.11.4
  - seaborn=0.13.1
  - shapely=2.0.1
  - sliderule=4.1.0
  - statsmodels=0.14.1
  - tqdm=4.66.1
  - unidecode=1.3.7
  - xmltodict=0.13.0
  - pip=23.3.2
  - jupyter-resource-usage==0.7.2
  - rio-tiler==6.2.8
  - morecantile==5.1.0
  - 
# Adding workspace to Eclipse Che

## Manual
Eclipse Che only requires a valid devfile to create a workspace. The devfile for the MAAP Eclipse Che workspace is located in this repository. Thus, we can just specify
the URL of this repository in  Eclipse Che workspace creation textbox.

## Kubernetes ConfigMap
Alternatively, if we have administrator access to Eclipse Che, we can add the workspace to the list of available workspaces in the `getting-started-sample` Kubernetes configmap. We can use `kubectl` as follows:

```bash
kubectl create configmap getting-started-samples --from-file=maap_sample.json -n eclipse-che
```

```bash
kubectl label configmap getting-started-samples app.kubernetes.io/part-of=che.eclipse.org app.kubernetes.io/component=getting-started-samples -n eclipse-che
```

Please note that some of the commands above may require administrator access to the Kubernetes cluster and the Eclipse Che namespace.

An example of the `maap_sample.json` file is provided in this repository. The file contains the following information:
```json
[
  {
    "displayName": "MAAP Python 3.10.13",
    "description": "Python 3.10.13 sample MAAP using vanilla environment",
    "tags": "maap, python 3.10.13",
    "url": "https://github.com/igabriel85/maap-theia",
    "icon": {
      "base64data": "<base64_encoded_data>",
      "mediatype": "image/png"
    }
  },
  {
    "displayName": "MAAP Jupyter Python 3.10.13",
    "description": "Python 3.10.13 sample MAAP using Jupyter environment",
    "tags": "maap, python 3.10.13",
    "url": "https://github.com/igabriel85/maap-jupyter",
    "icon": {
      "base64data": "<base64_encoded_data>",
      "mediatype": "image/png"
    }
  }
]
```
For custom icons, we must convert the image data into base64 encoding. We can use online tools such as [base64-image.de](https://www.base64-image.de/) to convert the image data to base64 encoding.

## Devfile Registry

We can also create a custom devfile registry. This registry contains the devfile for the MAAP Eclipse Che workspace. It will enable complete controll over what sample workspaces are available in Eclipse Che. The other methods will just add the workspace to the list of available workspaces in Eclipse Che.
For a complete overview of how we can use the Devfile Registry, please refer to the [MAAP Eclipse Che devfile registry](https://gitlab.dev.info.uvt.ro/sage/maap/che-dev-file-registry).


## Custom IDE

There are several way of adding custom IDE to Eclipse Che. 

### Custom IDE in plugin-registry

We can add the custom IDE to the plugin-registry. This will make the custom IDE available to all workspaces in Eclipse Che.
A custom version of the plugin registry can be found in the plugin registry repository: [che plugin registry](https://gitlab.dev.info.uvt.ro/sage/maap/che-plugin-registry)
First we need to edit the  che-editor-plugin.yaml file. This file contains the information about all plugins and IDEs supported by Eclipse CHE. We can add the following information to the file:

```yaml
version: 2.0.0
editors:
  - schemaVersion: 2.2.2
    metadata:
      name: igabriel85/jupyter-ide/1.0.0
      displayName: MAAP Jupyter Lab IDE
      description: Jupyter Lab IDE for MAAP
      icon: /images/notebook.svg
      attributes:
        publisher: igabriel85
        version: 1.0.0
        title: Jupyter Lab IDE for MAAP
        repository: 'https://github.com/igabriel85/maap-jupyter-ide'
        firstPublicationDate: '2024-03-12'
      components:
        - name: jupyter-ide
          container:
            image: 'quay.io/igabriel185/maap-jupyter-ide:latest'
            env:
              - name: JUPYTER_NOTEBOOK_DIR
                value: /projects
            mountSources: true
            memoryLimit: 512M
            endpoints:
              - name: jupyter
                targetPort: 3100
                exposure: public
                protocol: https
                attributes:
                  type: main
            attributes:
              ports:
                - exposedPort: 3100
  - schemaVersion: 2.2.2
    metadata:
      name: ws-skeleton/jupyter/5.7.0
      displayName: Jupyter Notebook
      description: Jupyter Notebook for Eclipse Che
      icon: /images/notebook.svg
      attributes:
        publisher: ws-skeleton
        version: 5.7.0
        title: Jupyter Notebook for Eclipse Che
        repository: 'https://github.com/ws-skeleton/che-editor-jupyter/'
        firstPublicationDate: '2019-02-05'
    components:
      - name: jupyter-notebook
        container:
          image: 'docker.io/ksmster/che-editor-jupyter:5.7.0'
          env:
            - name: JUPYTER_NOTEBOOK_DIR
              value: /projects
          mountSources: true
          memoryLimit: 512M
          endpoints:
            - name: jupyter
              targetPort: 8888
              exposure: public
              protocol: https
              attributes:
                type: main
        attributes:
          ports:
            - exposedPort: 8888
```

We should note that this example is not a complete che-editor.yaml file. It is just a snippet of the file to ilustrate how we can add our custom Jupyter lab IDE.

Next we need to generate the `v3` folder where all plugin information is stored. 
We first need to install che plugin registry generator:

```bash
npm i @eclipse-che/plugin-registry-generator
```

Next we generate the `v3` folder, note the che-editor.yaml file needs to be in the same folder as the command run:

```bash
plugin-registry-generator --root-folder:<user_defined_location>/che-plugin-registry > out.txt
```

Once this is completed we can build the plugin registry image using the build script:

```bash
./build.sh <tag> <organization> <label>
```

### Update plugin-registry in Eclipse Che

If the plugin registry has already been deployed and configured for Eclipse Che, we can update the plugin registry with the new custom IDE. 
Instruction can be found at this [link](https://access.redhat.com/documentation/en-us/red_hat_codeready_workspaces/2.0/html/administration_guide/customizing-the-devfile-and-plug-in-registries#building-and-running-a-custom-registry-image_customizing-the-devfile-and-plug-in-registries).

Alternatively, we can manually update plugin registry by, generating the v3 folder and copying it's content to the plugin registry pod, specifically into the `/var/www/html/v3` folder.

### Custom IDE using only the che-editor.yaml file

It is also possible to just make contents of the `v3` folder available via HTTP in a git repository. See [maap-che-plugin-registry](https://github.com/igabriel85/maap-plugin-registry) repository as an example.


### Custom IDE added directly to the workspace

See the Jupyter IDE devfile [repository](https://gitlab.dev.info.uvt.ro/sage/maap/maap-jupyter#inline-ide-definition) for an example.


# ToDos
- [x] initial functionality test.
- [ ] test S3fs mountpoints
- [ ] test additional scientific applications
- [ ] full scale functionality test