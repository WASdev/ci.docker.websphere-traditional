# Docker Hub Image

The files in this directory are used to build the `ibmcom/websphere-traditional` images on [Docker Hub](https://hub.docker.com/r/ibmcom/websphere-traditional/). These images contain the ILAN licensed IBM WebSphere Application Server traditional for Developers. If you wish to build these yourself just follow [these instructions](docker-build/README.md), otherwise please see below on how to extend our pre-built image with your application and configuration!

## Building an application image 

The Docker Hub image contains a tradittional WebSphere Application Server v9 instance with no applications or configuration applied to it.

### Best practices
According to Docker's best practices you should create a new image (`FROM ibmcom/websphere-traditional`) which adds a single application and the corresponding configuration.   You should avoid configuring the image manually (after it started) via Admin Console or wsadmin (unless it is for debugging purposes) because such changes won't be present if you spawn a new container from the image.  

Even if you `docker save` the manually configured container, the steps to reproduce the image from `ibmcom/websphere-traditional` will be lost and you will hinder your ability to update that image.

### Adding configuration during build phase (under construction)

Starting with `9.0.0.9` the `profile` Docker Hub images contain a script, `/work/applyConfig.sh`, which will apply the properties found inside the `/work/was-config.props` file.  

For example, if you had the following `was-config.props`:

```
ResourceType=JavaVirtualMachine
ImplementingResourceType=Server
ResourceId=Cell=!{cellName}:Node=!{nodeName}:Server=!{serverName}:JavaProcessDef=ID#JavaProcessDef_1183122130078:JavaVirtualMachine=ID#JavaVirtualMachine_1183122130078
AttributeInfo=jvmEntries
#
#
#Properties
#
initialHeapSize=2048 #integer,default(0)
```

You can then create a new image which has this configuration by simply building the following Dockerfile:

```
FROM ibmcom/websphere-traditional:profile
COPY was-config.props /work
RUN /work/applyConfig.sh
```

### Adding an applicationg during build phase (under construction)

Similar to the example above, you can also deploy an application by placing under the `/work/app` folder and running the script from `/work/installApp.sh`.  

Putting it all together, you would have a Dockerfile such as:

```
FROM ibmcom/websphere-traditional:profile
COPY was-config.props /work/
COPY myApp.war /work/app/
RUN /work/applyConfig.sh && /work/installApp.sh 
```


## How to run this image

When the container is started by using the IBM WebSphere Application Server traditional for Developers profile image, it takes the following environment variables:

* `UPDATE_HOSTNAME` (optional, set to `true` if the hostname should be updated from the default of `localhost`)
* `PROFILE_NAME` (optional, default is `AppSrv01`)
* `NODE_NAME` (optional, default is `DefaultNode01`)
* `SERVER_NAME` (optional, default is `server1`)

### Running the image by using the default values
  
```bash
   docker run --name was-server -h was-server -p 9043:9043 -p 9443:9443 -d \
   websphere-traditional:9.0.9.9-ilan
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

### Stopping the Application Server gracefully

```bash
docker stop --time=<timeout> <container-name>
```

Example:

```bash
docker stop --time=60 test
```
