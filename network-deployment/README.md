# IBM WebSphere Application Server traditional Network Deployment images

The contents of this directory can be used to build images for WebSphere Application Server traditional Network Deployment to create an ND cell. The steps are as follows:

1. Build an [install](install) image containing the product binaries.
2. Build an image with a [deployment manager](dmgr) profile.
3. Build a node image containing an [application server](appserver) and node agent profile or a [custom](custom) node with just the node agent profile.
