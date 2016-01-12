# Building an IBM WebSphere Application Server Classic Network Deployment image from binaries

An IBM WebSphere Application Server Classic Network Deployment image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)
* IBM WebSphere Application Server Classic Network Deployment  binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)

IBM WebSphere Application Server Classic Network Deployment install image is created in two steps using the following two Dockerfiles

1. Dockerfile.prereq
2. Dockerfile.install

Dockerfile.prereq does the following:
 
1. Installs IBM Installation Manager
2. Installs IBM WebSphere Application Server 
3. Updates IBM WebSphere Application Server with the Fixpack
4. When the container is started a tar file of the IBM WebSphere Application Server Classic Network Deployment installation is created

Dockerfile takes the values for the following variables during build time 
* user(optional)[default 'was'] - user used for installation
* group(optional)[default 'was'] - group the user belongs to
* URL(required) - URL from where the binaries are downloaded

Dockerfile.install does the following:
                                                                                                           
1. Extracts the tar file created by Dockerfile.prereq

## Building the IBM WebSphere Application Server Classic Network Deployment image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server Classic binaries on the FTP or HTTP server.
2. Clone this repository.
3. Move to the directory `websphere-classic/network-deployment/install`.
4. Build the prereq image using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> --build-arg URL=<URL> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

5. Run a container using the prereq image to get the tar file to the current folder using:

    ```bash
    docker run -v $PWD:/tmp <prereq-image-name>
    ```

6. Build the base install image using:       

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```


