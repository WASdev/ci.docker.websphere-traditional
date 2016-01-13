## Running the IBM WebSphere Application Server Classic for Developers Install image

When the container is started using the IBM WebSphere Application Server Classic for Developers Install image, it executes the createProfileAndStartServer script
which takes the following environment variables:

* PROFILE_NAME(optional) [default 'AppSrv01']
* CELL_NAME(optional)[default 'DefaultCell01']
* NODE_NAME(optional)[default 'DefaultNode01']
* HOST_NAME(optional)[default 'localhost']  

# Running the image using the default values

```bash
docker run --name <container-name> -h <container-name> -p 9060:9060 -p 9080:9080 -d <install-image-name>
```

Example:

```bash
docker run --name test -h test -p 9060:9060 -p 9080:9080 -d devinstall
```

# Running the image by passing values for the environment variables                                                                                                    
                                                                                                                              
```bash                                                                                                                                         
docker run --name <container-name> -h <container-name> -e HOST_NAME=<container-name> -e PROFILE_NAME=<profile-name> -e CELL_NAME=<cell-name> -e NODE_NAME=<node-name> -p 9060:9060 -p 9080:9080 -d <install-image-name>                  
```    

Example:

```bash                                                                                                                                        
docker run --name test -h test -e HOST_NAME=test -e PROFILE_NAME=AppSrv02 -e CELL_NAME=DefaultCell02 -e NODE_NAME=DefaultNode02 -p 9060:9060 -p 9080:9080 -d devinstall`
``` 

# Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

e.g

```bash                                                                                                                                         
docker logs -f --tail=all test                                                                                                      
``` 
