## Running the IBM WebSphere Application Server Classic for Developers Profile image

When the container is started using the IBM WebSphere Application Server Classic for Developers Profile image, it executes the start script
which takes the following environment variables:

* UPDATE_HOSTNAME(optional, has to be provided if hostname has to be changed from localhost)
* PROFILE_NAME(optional)[default 'AppSrv01']
* NODE_NAME(optional)[default 'DefaultNode01']

# Running the image using the default values

```bash
docker run --name <container-name> -h <container-name> -p 9060:9060 -p 9080:9080 -d <profile-image-name>
```

Example:

```bash
docker run --name test -h test -p 9060:9060 -p 9080:9080 -d devprofile
```

# Running the image by passing values for the environment variables                                                                                                    
                                                                                                                              
```bash                                                                                                                                         
docker run --name <container-name> -h <container-name> -e UPDATE_HOSTNAME=true -e PROFILE_NAME=<profile-name> -e NODE_NAME=<node-name> -p 9060:9060 -p 9080:9080 -d <profile-image-name>                  
```    

Example:

```bash                                                                                                                                        
docker run --name test -h test -e UPDATE_HOSTNAME=true -e PROFILE_NAME=AppSrv02 -e NODE_NAME=DefaultNode02 -p 9060:9060 -p 9080:9080 -d devprofile `
``` 

# Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

e.g

```bash                                                                                                                                         
docker logs -f --tail=all test                                                                                                      
``` 
