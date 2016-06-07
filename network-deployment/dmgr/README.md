# Building an IBM WebSphere Application Server Network Deployment traditional deployment manager image

An IBM WebSphere Application Server Network Deployment deployment manager image can be built by extending the Network Deployment install image.

The Dockerfile takes the values for the following variables at build time:
* CELL_NAME (optional, default is 'DefaultCell01') - cell name
* NODE_NAME (optional, default is 'DefaultNode01') - node name
* PROFILE_NAME (optional, default is 'Dmgr01') - profile name
* HOST_NAME (optional, default is 'dmgr') - host name

The Dockerfile takes the following actions:

1. Uses the `nd` install image as a base image
2. Creates a deployment manager profile
3. Exposes the required ports
4. Copies the startup script to the image
5. When the container is started the deployment manager is started

## Building the IBM WebSphere Application Server Network Deployment traditional deployment manager image

1. Clone this repository
3. Build the `nd` install image following the [install build instructions](../install/README.md), if not built already
3. Move to the directory `network-deployment/dmgr`
4. Build the deployment manager image by using:

    ```bash
    docker build -t <dmgr-image-name> .
    ```

## Running the IBM WebSphere Application Server Network Deployment traditional deployment manager image

1. Create a docker network for the Network Deployment cell topology by using:

   ```bash
   docker network create <network-name>
   ```
   This command creates a user defined bridge network, to create an overlay network, see [Get started with multi-host networking docker documentation](https://docs.docker.com/engine/userguide/networking/get-started-overlay/).

   Example:

   ```bash
   docker network create cell-network
   ```

2. Run the deployment manager image by using:

   ```bash
   docker run --name <container-name> -h <container-name> --net=<network-name> -p 9060:9060 -d <dmgr-image-name>
   ```

   Example:

   ```bash
   docker run --name dmgr -h dmgr --net=cell-network  -p 9060:9060 -d dmgr
   ```
