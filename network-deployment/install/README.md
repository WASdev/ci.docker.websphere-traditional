# Building an IBM WebSphere Application Server Classic Network Deployment image from binaries

An IBM WebSphere Application Server Classic Network Deployment image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)

  IBM Installation Manager binaries:
  * Install_Mgr_v1.6.2_Lnx_WASv8.5.5.zip(CIK2GML)

* IBM WebSphere Application Server Classic Network Deployment  binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)
 
  IBM WebSphere Application Server Classic v8.5.5 Network Deployment binaries:
  * WASND_v8.5.5_1of3.zip(CIK2HML)
  * WASND_v8.5.5_2of3.zip(CIK2IML)
  * WASND_v8.5.5_3of3.zip(CIK2JML)

  Fixpack 8.5.5.8 binaries:
  * 8.5.5-WS-WAS-FP0000008-part1.zip
  * 8.5.5-WS-WAS-FP0000008-part2.zip

IBM WebSphere Application Server Classic Network Deployment install image is created in two steps using the following two Dockerfiles to reduce the final image size:

1. [Dockerfile.prereq](Dockerfile.prereq)
2. [Dockerfile.install](Dockerfile.install)

Dockerfile.prereq perform the following actions:
 
1. Installs IBM Installation Manager
2. Installs IBM WebSphere Application Server 
3. Updates IBM WebSphere Application Server with the Fixpack
4. When the container is started a tar file of the IBM WebSphere Application Server Classic Network Deployment installation is created

Dockerfile.prereq take the values for the following variables during build time: 
* user(optional)[default 'was'] - user used for installation
* group(optional)[default 'was'] - group the user belongs to
* URL(required) - URL from where the binaries are downloaded

Dockerfile.install perform the following action:
                                                                                                           
1. Extracts the tar file created by Dockerfile.prereq

## Building the IBM WebSphere Application Server Classic Network Deployment image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server Classic binaries on the FTP or HTTP server.
2. Clone this repository.
3. Move to the directory `network-deployment/install`.
4. Build the prereq image using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> --build-arg URL=<URL> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

5. Run a container using the prereq image to create the tar file in the current folder using:

    ```bash
    docker run -v $(pwd):/tmp <prereq-image-name>
    ```

6. Build the install image using:       

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```


