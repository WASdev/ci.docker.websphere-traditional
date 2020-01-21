# Docker Hub Image

The files in this directory are used to build the `ibmcom/websphere-traditional` images on [Docker Hub](https://hub.docker.com/r/ibmcom/websphere-traditional/). These images contain the ILAN licensed IBM WebSphere Application Server traditional. If you wish to build these yourself just follow [these instructions](docker-build/9.0.5.x/README.md), otherwise please see below on how to extend our pre-built image with your application and configuration!  Once you're ready to deploy this into Kubernetes, please see our [helm chart](https://github.com/IBM/charts/tree/master/stable/ibm-websphere-traditional).

**Note:** Have you considered trying out WebSphere Liberty?  It's based on the Open Source project `Open Liberty`, fully supports Java EE8 and MicroProfile 2.0, and it's much lighter, faster and easier to configure than WAS traditional. You can try it today for free from [Docker Hub](https://hub.docker.com/_/websphere-liberty/). If you have entitlement for WAS traditional you already have entitlement for Liberty included.  Find out more about how to use WebSphere Liberty in Kubernetes [here](https://www.ibm.com/blogs/bluemix/2018/10/certified-kubernetes-deployments-for-websphere-liberty/).

## Building an application image 

The Docker Hub image contains a traditional WebSphere Application Server v9 instance with no applications or configuration applied to it.

### Best practices

According to Docker's best practices you should create a new image (`FROM ibmcom/websphere-traditional`) which adds a single application and the corresponding configuration.   You should avoid configuring the image manually (after it started) via Admin Console or wsadmin (unless it is for debugging purposes) because such changes won't be present if you spawn a new container from the image.  

Even if you `docker save` the manually configured container, the steps to reproduce the image from `ibmcom/websphere-traditional` will be lost and you will hinder your ability to update that image.

The key point to take-away from the sections below is that your application Dockerfile should always follow a pattern similar to:

```
FROM ibmcom/websphere-traditional:<version>
# copy property files and jython scripts, using the flag `--chown=was:root` to set the appropriate permission
RUN /work/configure.sh
```

This will result in a Docker image that has your application and configuration pre-loaded, which means you can spawn new fully-configured containers at any time.

![App Image](/graphics/twas_app_image.png)

### Adding properties during build phase 

Starting with `9.0.0.9` the `profile` Docker Hub images contain a script, `/work/applyConfig.sh`, which will apply the [config properties](https://www.ibm.com/support/knowledgecenter/en/SSAW57_9.0.0/com.ibm.websphere.nd.multiplatform.doc/ae/rxml_7propbasedconfig.html) found inside the `/work/config/*.props` file.  This script will be run with the server in `stopped` mode and the props will be applied in alphabetic order.

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
FROM ibmcom/websphere-traditional:latest
COPY --chown=was:root was-config.props /work/config
RUN /work/configure.sh
```

You may use numeric prefix on your prop files names, so props the have dependencies can be applied in an adequate order.

### Adding an application and advanced configuration during build phase 

Similar to the example above, you can also deploy an application and advanced configuration by placing their Jython (`.py`) scripts under
the folder `/work/config`.  

Putting it all together, you would have a Dockerfile such as:

```
FROM ibmcom/websphere-traditional:latest
COPY --chown=was:root was-config.props /work/config
COPY --chown=was:root myApp.war /work/app
COPY --chown=was:root myAppDeploy.py dataSourceConfig.py /work/config
RUN /work/configure.sh
```
### Installing iFixes

Normally it is best to use fixpacks instead of installing individual iFixes but some circumstances may require the ability to install a test fix. In order to install iFixes on the image, you must first get access to the agent installer. Follow the instructions at https://www.ibm.com/support/knowledgecenter/en/SSFHJY_2.0.0/deploy/ibm_install_manager.html until you have downloaded the agent.installer.linux.gtk.x86_64*.zip file to your system. 

Once you have the iFix and the agent installer on the system you are building your image on, configure the dockerfile to extract the installer and run the installer on the iFix as shown in the example dockerfile below.
```
FROM ibmcom/websphere-traditional:9.0.0.10
COPY A.ear /work/config/A.ear
COPY install_app.py /work/config/install_app.py
RUN /work/configure.sh

COPY agent.installer.linux.gtk.x86_64*.zip /work
RUN cd /work && \
	unzip agent.installer.linux.gtk.x86_64*.zip -d /work/InstallationManagerKit && \
	rm -rf agent.installer.linux.gtk.x86_64*.zip  

COPY 9.0.0.10-WS-WAS-IFPH15201.zip /work/
RUN /work/InstallationManagerKit/tools/imcl install 9.0.0.10-WS-WAS-IFPH15201 -repositories /work/9.0.0.10-WS-WAS-IFPH15201.zip -installationDirectory /opt/IBM/WebSphere/AppServer -dataLocation /opt/IBM/WebSphere/AppServerIMData && \
	rm -Rf /tmp/secureStorePwd /tmp/secureStore /work/InstallationManagerKit
```

You can find more information about the imcl command at https://www.ibm.com/support/knowledgecenter/en/SSDV2W_1.8.4/com.ibm.cic.commandline.doc/topics/c_imcl_container.html
### Logging configuration
	
By default, the Docker Hub image is using High Performance Extensible Logging (HPEL) mode and is outputing logs in JSON format. This logging configuration will make the docker container a lot easier to work with ELK stacks. 

Alternatively, user can use basic logging mode is plain text format. You can switch the logging mode to basic via the following Dockerfile:

```
FROM ibmcom/websphere-traditional:latest
ENV ENABLE_BASIC_LOGGING=true
RUN /work/configure.sh
```
    
### Running Jython scripts individually

If you have some Jython scripts that must be run in a certain order, or if they require parameters to be passed in, then you can directly call
the `/work/configure.sh` script - once for each script.  

Let's say you have 2 scripts, `configA.py` and `configB.py`, which must be run in that order.  You can configure them via the following Dockerfile:

```
FROM ibmcom/websphere-traditional:latest
COPY --chown=was:root configA.py configB.py /work/
RUN /work/configure.sh /work/configA.py <args> \
    && /work/configure.sh /work/configB.py <args>
```

### Runtime configuration

How about properties that are dynamic and depend on the environment (eg: changing JAAS passwords or data source host at runtime)?  tWAS is not nearly as dynamic as Liberty, but we have augmented the `start_server` script to look into `/etc/websphere` for any property files that need to applied to the server.

So during `docker run` you can setup a volume that mounts property files into `/etc/websphere`, such as:

```bash
docker run -v /config:/etc/websphere  -p 9043:9043 -p 9443:9443 websphere-traditional:9.0.0.9-profile
```

Similarly to build-phase props, the dynamic runtime props will also be applied in alphabetic order, so you can also use numeric prefixes to guarantee dependent props are applied in an adequate order.

![Dynamic](/graphics/twas_container_local.png)


## How to run this image

When the container is started by using the IBM WebSphere Application Server traditional for Developers profile image, it takes the following environment variables:

* `UPDATE_HOSTNAME` (optional, set to `true` if the hostname should be updated from the default of `localhost`)
* `PROFILE_NAME` (optional, default is `AppSrv01`)
* `NODE_NAME` (optional, default is `DefaultNode01`)
* `SERVER_NAME` (optional, default is `server1`)

### Running the image by using the default values
  
```bash
   docker run --name was-server -h was-server -p 9043:9043 -p 9443:9443 -d \
   websphere-traditional:9.0.0.9-profile
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
  -p 9043:9043 -p 9443:9443 -d websphere-traditional:profile 
``` 

### Retrieving the password

The admin console user id is default to ```wsadmin``` and the initial wsadmin user password is
in ```/tmp/PASSWORD```
```
   docker exec was-server cat /tmp/PASSWORD
```

### How to check the WebSphere Application Server installed level and ifixes

```
   docker run websphere-traditional:9.0.0.9-ilan versionInfo.sh -ifixes
```

### Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

Example:

```bash
docker logs -f --tail=all test
``` 

The logs from this container is also available inside `/logs`, therefore you can setup a volume mount to persist these logs into an external directory:

![Logs](/graphics/persisted_logs.png)


### Stopping the Application Server gracefully

```bash
docker stop --time=<timeout> <container-name>
```

Example:

```bash
docker stop --time=60 test
```
