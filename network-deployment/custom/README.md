# Building an IBM WebSphere Application Server Network Deployment traditional custom node image

An IBM WebSphere Application Server Network Deployment custom node image can be built extending the Network Deployment install image.

The Dockerfile takes the values for the following variables at build time:
* CELL_NAME (optional, default is 'CustomCell') - cell name
* NODE_NAME (optional, default is 'CustomNode') - node name
* PROFILE_NAME (optional, default is 'Custom01') - profile name
* HOST_NAME (optional, default is 'localhost') - host name

The Dockerfile takes the following actions:

1. Uses the `nd` install image as a base image
2. Creates a custom node profile
3. Exposes the required ports
4. Copies the update scripts to the image
5. When the container is started, the node is federated to the deployment manager and the nodeagent is started

## Building the IBM WebSphere Application Server Network Deployment traditional custom node image

1. Clone this repository
2. Build the `nd` install image following the [install build instructions](../install/README.md), if not built already
3. Move to the directory `network-deployment/custom`
4. Build the custom node image by using:

    ```bash
    docker build -t <customnode-image-name> .
    ```

## Running the IBM WebSphere Application Server Network Deployment traditional custom node image

Running the custom node image by using the default values:

```bash
docker run --name <container-name> -h <container-name> --net=<network-name> -d <customnode-image-name>
```

Example:

```bash
docker run --name custom1 -h custom1 --net=cell-network -d custom
```

Running the Custom Node image by passing values for the environment variables:

```bash
docker run --name <container-name> -h <container-name> --net=<network-name> -e PROFILE_NAME=<profile-name> -e NODE_NAME=<node-name> -e DMGR_HOST=<dmgr-host> -e DMGR_PORT=<dmgr-port> -d <customnode-image-name>
```

Example:

```bash
docker run --name custom1 -h custom1 --net=cell-network -e PROFILE_NAME=Custom01 -e NODE_NAME=CustomNode01 -e DMGR_HOST=dmgr -e DMGR_PORT=8879 -d custom
```
