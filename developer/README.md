# Docker Hub Image

The files in this directory are used to build the `ibmcom/websphere-traditional` images on [Docker Hub](https://hub.docker.com/r/ibmcom/websphere-traditional/). These images contain the ILAN licensed IBM WebSphere Application Server traditional for Developers. If you wish to build these yourself just follow [these instructions](build-image.md), otherwise please see below on how to extend our pre-built image with your application and configuration!

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
