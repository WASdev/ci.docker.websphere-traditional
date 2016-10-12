# Building an IBM WebSphere Application Server Network Deployment traditional image from binaries

An IBM WebSphere Application Server Network Deployment traditional image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)

  IBM Installation Manager binaries:
  * Install_Mgr_v1.6.2_Lnx_WASv8.5.5.zip (CIK2GML)

* IBM WebSphere Application Server Network Deployment traditional binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)

  IBM WebSphere Application Server Network Deployment traditional V8.5.5 binaries:
  * WASND_v8.5.5_1of3.zip (CIK2HML)
  * WASND_v8.5.5_2of3.zip (CIK2IML)
  * WASND_v8.5.5_3of3.zip (CIK2JML)

  Fixpack V8.5.5.9 binaries:
  * 8.5.5-WS-WAS-FP0000009-part1.zip
  * 8.5.5-WS-WAS-FP0000009-part2.zip

  IBM WebSphere SDK Java Technology Edition V7.1.3.0 binaries:
  * 7.1.3.30-WS-IBMWASJAVA-part1.zip
  * 7.1.3.30-WS-IBMWASJAVA-part2.zip

An IBM WebSphere Application Server Network Deployment traditional install image is created in two steps by using the following two Dockerfiles to reduce the final image size:

1. [Dockerfile.prereq](Dockerfile.prereq)
2. [Dockerfile.install](Dockerfile.install)

Dockerfile.prereq takes the following actions:
 
1. Installs IBM Installation Manager
2. Installs IBM WebSphere Application Server 
3. Updates IBM WebSphere Application Server with the Fixpack
4. When the container is started a .tar file for the IBM WebSphere Application Server Network Deployment traditional  installation is created

Dockerfile.prereq takes the values for the following variables at build time: 
* user (optional, default is 'was') - user used for the installation
* group (optional, default is 'was') - group the user belongs to
* URL (required) - URL from where the binaries are downloaded

Dockerfile.install takes the following action:

1. Extracts the .tar file created by Dockerfile.prereq

## Building the IBM WebSphere Application Server Network Deployment traditional image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server traditional binaries on the FTP or HTTP server
2. Clone this repository
3. Move to the directory `network-deployment/install`
4. Build the prereq image by using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> --build-arg URL=<URL> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

5. Run a container by using the prereq image to create the .tar file in the current folder by using:

    ```bash
    docker run --rm -v $(pwd):/tmp <prereq-image-name>
    ```
    
    Note: the user that the image is running as (UID 1) needs to have write access to the current directory.

6. Build the install image by using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```

