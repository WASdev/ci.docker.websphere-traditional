# Building an IBM WebSphere Application Server Network Deployment traditional application server image

An IBM WebSphere Application Server Network Deployment traditional application server image can be built by extending the Network Deployment install image.

The Dockerfile takes the values for the following variables at build time:
* CELL_NAME (optional, default is 'ServerCell') - cell name
* NODE_NAME (optional, default is 'ServerNode') - node name
* PROFILE_NAME (optional, default is 'AppSrv01') - profile name
* HOST_NAME (optional, default is 'localhost') - host name

The Dockerfile takes the following actions:

1. Uses the `nd` install image as a base image
2. Creates the application server profile
3. Exposes the required ports
4. Copies the update scripts to the image
5. When the container is started, the node is federated to the deployment manager and the nodeagent and server are started

## Building the IBM WebSphere Application Server Network Deployment traditional application server image

1. Clone this repository
2. Build the `nd` install image following the [install build instructions](../install/README.md), if not built already
3. Move to the directory `network-deployment/appserver`
4. Build the application server image by using:

    ```bash
    docker build -t <appserver-image-name> .
    ```

## Running the IBM WebSphere Application Server Network Deployment traditional application server image

Run the Application Server image by using the default values:

```bash
docker run --name <container-name> -h <container-name> --net=<network-name> -p 9080:9080 -d <appserver-image-name>
```

Example:

```bash
docker run --name server1 -h server1 --net=cell-network -p 9080:9080 -d appserver
```

Running the Application Server image by passing values for the environment variables:

```bash
docker run --name <container-name> -h <container-name> --net=<network-name> -e PROFILE_NAME=<profile-name> -e NODE_NAME=<node-name> -e DMGR_HOST=<dmgr-host> -e DMGR_PORT=<dmgr-port> -d <appserver-image-name>
```

Example:

```bash
docker run --name server1 -h server1 --net=cell-network -e PROFILE_NAME=AppSrv01 -e NODE_NAME=ServerNode01 -e DMGR_HOST=dmgr -e DMGR_PORT=8879 -d appserver
```
