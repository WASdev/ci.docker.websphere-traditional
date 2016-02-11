## Running the IBM WebSphere Application Server traditional for Developers profile image

When the container is started by using the IBM WebSphere Application Server traditional for Developers profile image, the start script is executed and takes the following environment variables:

* UPDATE_HOSTNAME (optional, set to 'true' if the hostname should be updated from the default of 'localhost')
* PROFILE_NAME (optional, default is 'AppSrv01')
* NODE_NAME (optional, default is 'DefaultNode01') 

# Running the image by using the default values

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
docker run --name test -h test -e UPDATE_HOSTNAME=true -e PROFILE_NAME=AppSrv02 -e NODE_NAME=DefaultNode02 -p 9060:9060 -p 9080:9080 -d devprofile 
``` 

# Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

Example:

```bash                                                                                                                                         
docker logs -f --tail=all test                                                                                                      
``` 
