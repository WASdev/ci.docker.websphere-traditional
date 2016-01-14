# Building an IBM WebSphere Application Server Classic Network Deployment, Deployment Manager image  

An IBM WebSphere Application Server Network Deployment, Deployment Manager image can be built extending the Network Deployment install image

The Dockerfile take the values for the following variables during build time:
* CELL_NAME(optional)[default 'DefaultCell01'] - cell name
* NODE_NAME(optional)[default 'DefaultNode01'] - node name
* PROFILE_NAME(optional)[default 'Dmgr01'] - profile name
* HOST_NAME(optional)[default 'dmgr'] - host name

Dockerfile perform the following actions:
 
1. Uses the nd install image as base image
2. Creates deployment manager profile
3. Exposes the required ports
4. Copies the startup script to the image 
5. When the container is started the deployment manager is created

## Building the IBM WebSphere Application Server Classic Network Deployment, Deployment Manager image

1. Clone this repository.
3. Build the nd install image following the [install build instructions](../install/README.md), if not built already.
3. Move to the directory `network-deployment/dmgr`.
4. Build the dmgr image using:

    ```bash
    docker build -t <dmgr-image-name> .
    ```

## Running the IBM WebSphere Application Server Classic Network Deployment, Deployment Manager image

1. Create a docker network for the Network Deployment cell Topology using:
   
   ```bash
   docker network create <network-name>
   ```
   The command provided above creates an user defined bridge network, for creating overlay network refer [Get started with multi-host networking docker documentation](https://docs.docker.com/engine/userguide/networking/get-started-overlay/)

   Example:
  
   ```bash                                                                                          
   docker network create cell-network                                                             
   ```

2. Running the Deployment Manager image using:

   ```bash
   docker run --name <container-name> -h <container-name> --net=<network-name> -p 9060:9060 -d <dmgr-image-name>
   ```

   Example:

   ```bash                                                                                                                               
   docker run --name dmgr -h dmgr --net=cell-network -p 9060:9060 -d dmgr                                                 
   ```

