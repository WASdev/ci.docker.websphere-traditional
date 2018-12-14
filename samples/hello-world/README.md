# Hello World

A simple `Hello World` application that demonstrate a basic pattern for deploying an application into IBM Cloud Private using the official helm chart.

## Building the application image
Dockerfile adds three things to build application image
1. application EAR file
2. application installation script (Jython)
3. sample properties file that increases container thread pool to 100

Run following command inside this directory:

`docker build -t app .`

## Pushing the image to the private image registry

Push the built image to the private image registry of IBM Cloud Private. See [Pushing and pulling images](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.1/manage_images/using_docker_cli.html).

1. Log in to your private image registry.

    `docker login <cluster_CA_domain>:8500`

2. Tag the image.

    `docker tag imagename:tagname <cluster_CA_domain>:8500/namespacename/imagename:tagname`

3. Push the image to the private image registry.

    `docker push <cluster_CA_domain>:8500/namespacename/imagename:tagname`

## Deploying the application into IBM Cloud Private using a Helm chart

Let's use the Helm command line interface (CLI) to manage releases in your IBM Cloud Private cluster. See [Setting up the Helm CLI](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.1/app_center/create_helm_cli.html).

