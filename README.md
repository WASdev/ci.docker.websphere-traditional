# Image Overview

The official container images for WebSphere Application Server Base are available from IBM Container Registry (icr.io). Images can be pulled from icr.io without rate limits and authentication. You can see a list of images provided [here](/docs/images.md).

These images contain the ILAN licensed IBM WebSphere Application Server traditional. For production use or if you wish to build these yourself just follow [these instructions](docker-build/9.0.5.x/README.md), otherwise please see below on how to extend our pre-built image with your application and configuration!

**Note:** Have you considered trying out WebSphere Liberty?  It's based on the Open Source project `Open Liberty`, fully supports Java EE8 and MicroProfile 2.0, and it's much lighter, faster and easier to configure than WAS traditional. You can try it today for free from icr.io. See [Liberty container images](https://www.ibm.com/docs/en/was-liberty/base?topic=images-liberty-container) for more information. If you have entitlement for WAS traditional you already have entitlement for Liberty included.  Find out more about how to use WebSphere Liberty in Kubernetes [here](https://www.ibm.com/blogs/bluemix/2018/10/certified-kubernetes-deployments-for-websphere-liberty/).

## Building an application image 

The container image contains a traditional WebSphere Application Server v9 or v855 instance with no applications or configuration applied to it.

### Best practices

According to best practices for container images you should create a new image (`FROM icr.io/appcafe/websphere-traditional`) which adds a single application and the corresponding configuration.   You should avoid configuring the image manually (after it started) via Admin Console or wsadmin (unless it is for debugging purposes) because such changes won't be present if you spawn a new container from the image.  

Even if you `docker save` the manually configured container, the steps to reproduce the image from `icr.io/appcafe/websphere-traditional` will be lost and you will hinder your ability to update that image.

The key point to take-away from the sections below is that your application Dockerfile should always follow a pattern similar to:

```
FROM icr.io/appcafe/websphere-traditional:<version>
# copy property files and jython scripts, using the flag `--chown=was:root` to set the appropriate permission
RUN /work/configure.sh
```

This will result in a container image that has your application and configuration pre-loaded, which means you can spawn new fully-configured containers at any time.

![App Image](/graphics/twas_app_image.png)

### Adding properties during build phase 

The container images contain a script, `/work/applyConfig.sh`, which will apply the [config properties](https://www.ibm.com/support/knowledgecenter/SSEQTP_9.0.5/com.ibm.websphere.base.doc/ae/txml_property_configuration.html) found inside the `/work/config/*.props` file.  This script will be run with the server in `stopped` mode and the prop files will be applied in alphabetic order.

For example, if you had the following `/work/config/001-was-config.props`:

```
ResourceType=JavaVirtualMachine
ImplementingResourceType=Server
ResourceId=Cell=!{cellName}:Node=!{nodeName}:Server=!{serverName}:JavaProcessDef=:JavaVirtualMachine=
AttributeInfo=jvmEntries
#
#
#Properties
#
initialHeapSize=2048 #integer,default(0)
```

You can then create a new image which has this configuration by simply building the following Dockerfile:

```
FROM icr.io/appcafe/websphere-traditional:latest
COPY --chown=was:root 001-was-config.props /work/config/
RUN /work/configure.sh
```

You may use numeric prefixes on your prop file names, so props that have dependencies can be applied in an adequate order.

### Adding an application and advanced configuration during build phase 

Similar to the example above, you can also deploy an application and advanced configuration by placing your Jython (`.py`) scripts under
the folder `/work/config`.  

Putting it all together, you would have a Dockerfile such as:

```
FROM icr.io/appcafe/websphere-traditional:latest
COPY --chown=was:root was-config.props /work/config/
COPY --chown=was:root myApp.war /work/app/
COPY --chown=was:root myAppDeploy.py dataSourceConfig.py /work/config/
RUN /work/configure.sh
```
### Installing iFixes

Normally it is best to use fixpacks instead of installing individual iFixes but some circumstances may require the ability to install a test fix. In order to install iFixes on the image, you must first get access to the agent installer and the Fix Central for the required download:
* 1. Follow the instructions at https://www.ibm.com/support/pages/node/1115169 until you have downloaded the agent.installer.linux.gtk*.zip file to your system. For example, the installer zip for a linux x86_64 will be similar to `agent.installer.linux.gtk.x86_64_1.9.2003.20220917_1018.zip`.
* 2. Follow the Fix Central https://www.ibm.com/support/fixcentral/ to select the ifix matched to your product version and platform.  For example, an ifix `PH47531` for the platform of linux x86_64 will be similar to `9.0.0.0-ws-wasprod-ifph47531.zip` 

Once you have the iFix and the agent installer on the system you are building your image on, configure the dockerfile to extract the installer and run the installer on the iFix as shown in the example dockerfile below.
```
FROM icr.io/appcafe/websphere-traditional:latest
COPY A.ear /work/config/A.ear
COPY install_app.py /work/config/install_app.py
RUN /work/configure.sh

COPY agent.installer.linux.gtk*.zip /work
RUN cd /work && \
	unzip agent.installer.linux.gtk*.zip -d /work/InstallationManagerKit && \
	rm -rf agent.installer.linux.gtk*.zip  

COPY **YOUR_DOWNLADED_IFIX.zip** /work/
	RUN /work/InstallationManagerKit/tools/imcl install **THE_IFIX_FIX_NAME** -repositories /work/**YOUR_DOWNLADED_IFIX.zip** -installationDirectory /opt/IBM/WebSphere/AppServer -dataLocation /opt/IBM/WebSphere/AppServerIMData && \
	rm -Rf /tmp/secureStorePwd /tmp/secureStore /work/InstallationManagerKit
```

NOTE:
* Replace the value YOUR_DOWNLADED_IFIX.zip with your downloaded ifix
* Replace the value THE_IFIX_FIX_NAME with the selected ifix name.  If you're not sure about the ifix fix name, you may unzip the ifix zip and retrieve the fix name from the file `fix_name.txt`. Please be aware there may be case sensitivity between fix name and the zip file name. See the example from linux ifix on the replaced values:
```
COPY 9.0.0.0-ws-wasprod-ifph47531.zip /work
RUN /work/InstallationManagerKit/tools/imcl install 9.0.0.0-WS-WASProd-IFPH47531 -repositories /work/9.0.0.0-ws-wasprod-ifph47531.zip …
```

You can find more information about the imcl command at https://www.ibm.com/support/knowledgecenter/en/SSDV2W_1.8.4/com.ibm.cic.commandline.doc/topics/c_imcl_container.html
### Logging configuration
	
By default, the container image is using High Performance Extensible Logging (HPEL) mode and is outputing logs in JSON format. This logging configuration will make the container image a lot easier to work with ELK stacks. 

Alternatively, user can use basic logging mode is plain text format. You can switch the logging mode to basic via the following Dockerfile:

```
FROM icr.io/appcafe/websphere-traditional:latest
ENV ENABLE_BASIC_LOGGING=true
RUN /work/configure.sh
```
    
### Running Jython scripts individually

If you have some Jython scripts that must be run in a certain order, or if they require parameters to be passed in, then you can directly call
the `/work/configure.sh` script - once for each script.  

Let's say you have 2 scripts, `configA.py` and `configB.py`, which must be run in that order.  You can configure them via the following Dockerfile:

```
FROM icr.io/appcafe/websphere-traditional:latest
COPY --chown=was:root configA.py configB.py /work/
RUN /work/configure.sh /work/configA.py <args> \
    && /work/configure.sh /work/configB.py <args>
```

### Runtime configuration

How about properties that are dynamic and depend on the environment (eg: changing JAAS passwords or data source host at runtime)?  Traditional WAS is not nearly as dynamic as Liberty, but we have augmented the `start_server` script to look into `/etc/websphere` for any property files that need to applied to the server.

So during `docker run` you can setup a volume that mounts property files into `/etc/websphere`, such as:

```bash
docker run -v /config:/etc/websphere  -p 9043:9043 -p 9443:9443 websphere-traditional:latest
```

Similarly to build-phase props, the dynamic runtime props will also be applied in alphabetic order, so you can also use numeric prefixes to guarantee dependent props are applied in an adequate order.

![Dynamic](/graphics/twas_container_local.png)


## How to run this image

When the container is started by using the IBM WebSphere Application Server traditional image, it takes the following environment variables:

* `UPDATE_HOSTNAME` (optional, set to `true` if the hostname should be updated from the default of `localhost`)
* `PROFILE_NAME` (optional, default is `AppSrv01`)
* `NODE_NAME` (optional, default is `DefaultNode01`)
* `SERVER_NAME` (optional, default is `server1`)

### Running the image by using the default values
  
```bash
   docker run --name was-server -h was-server -p 9043:9043 -p 9443:9443 -d \
   websphere-traditional:latest
```

### Running the image by passing values for the environment variables

```bash
docker run --name <container-name> -h <container-name> \
  -e UPDATE_HOSTNAME=true -e PROFILE_NAME=<profile-name> \
  -e NODE_NAME=<node-name> -e SERVER_NAME=<server-name> \
  -p 9043:9043 -p 9443:9443 -d <profile-image-name>
```    

Example:

```bash
docker run --name test -h test -e UPDATE_HOSTNAME=true \
  -e PROFILE_NAME=AppSrv02 -e NODE_NAME=DefaultNode02 -e SERVER_NAME=server2 \
  -p 9043:9043 -p 9443:9443 -d websphere-traditional:latest 
``` 

### Retrieving the password

The admin console user id is defaulted to ```wsadmin``` and the initial wsadmin user password is
in ```/tmp/PASSWORD```
```
   docker exec was-server cat /tmp/PASSWORD
```
### Retrieving the keystore password

The initial keystore, truststore, and rootstore password is in ```/tmp/KEYSTORE_PASSWORD```
```
   docker exec was-server cat /tmp/KEYSTORE_PASSWORD
```

### How to check the WebSphere Application Server installed level and ifixes

```
   docker run websphere-traditional:latest versionInfo.sh -ifixes
```

### Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

Example:

```bash
docker logs -f --tail=all test
``` 

The logs from this container are also available inside `/logs`, therefore you can setup a volume mount to persist these logs into an external directory:

![Logs](/graphics/persisted_logs.png)


### Stopping the Application Server gracefully

```bash
docker stop --time=<timeout> <container-name>
```

Example:

```bash
docker stop --time=60 test
```
### Checking the Image Version

Using podman (or docker) you can check the date the image was created using the following command.

```bash
podman images websphere-traditional
```
You can then check the output for the creation date
```bash
REPOSITORY                              TAG         IMAGE ID      CREATED     SIZE
icr.io/appcafe/websphere-traditional  latest      f5dd9da02c85  7 days ago  1.91 GB
```

If you would like to check the version of websphere running inside of your image, you can run the following command against the image. Replace "websphere-traditional" with your image name if you want to check an image you built.
```bash
podman run --entrypoint="./opt/IBM/WebSphere/AppServer/bin/versionInfo.sh" websphere-traditional
```

### Updating to the Latest Version

1. Find the currently running containers using the websphere-traditional image. Take note of their container ID
```bash
podman ps -a
```
2. Stop and remove the running websphere-traditional containers. Both of these commands will output the container ID when completed
```bash
podman stop <container_id_from_step_1>
podman rm <container_id_from_step_1>
```
3. Pull the updated image. The tag should be for the version you are using
```bash
podman pull icr.io/appcafe/websphere-traditional:latest
```
4. Rebuild images that use the websphere-traditional image. Make sure they are using the same "FROM" that you pulled in step 3
5. Run the newly pulled and built container images

## Contributions

For issues relating specifically to the WebSphere Traditional container images, Dockerfiles and scripts, please use the [GitHub issues tracker](https://github.com/WASdev/ci.docker.websphere-traditional/issues). For general issues relating to WebSphere Application Server runtime, you can get help through the WASdev community or, if you have production licenses for WebSphere Application Server, via the usual [support channels](https://www.ibm.com/docs/en/was/latest?topic=getting-help). See our guidelines for contributions [here](https://github.com/WASdev/ci.docker.websphere-traditional/blob/main/CONTRIBUTING.md).
