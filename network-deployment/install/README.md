# Building an IBM WebSphere Application Server Network Deployment traditional image from binaries

The following instructions can be used to build an IBM WebSphere Application Server Network Deployment traditional base image from binaries for V8.5.5.

## Binaries required for V8.5.5

* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)

  IBM Installation Manager binaries:
  * Install_Mgr_v1.6.2_Lnx_WASv8.5.5.zip (CIK2GML)

* IBM WebSphere Application Server Network Deployment traditional binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)

  IBM WebSphere Application Server Network Deployment traditional V8.5.5 binaries:
  * WASND_v8.5.5_1of3.zip (CIK2HML)
  * WASND_v8.5.5_2of3.zip (CIK2IML)
  * WASND_v8.5.5_3of3.zip (CIK2JML)

  Fixpack V8.5.5.10 binaries:
  * 8.5.5-WS-WAS-FP0000010-part1.zip
  * 8.5.5-WS-WAS-FP0000010-part2.zip

  IBM WebSphere SDK Java Technology Edition V8.0.2.10 binaries:
  * 8.0.2.10-WS-IBMWASJAVA-Linux.zip

## Building the IBM WebSphere Application Server Network Deployment traditional image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server traditional binaries on the FTP or HTTP server
2. Clone this repository
3. Move to the directory `network-deployment/install`
4. Build the prereq image for V8.5.5:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> \
      --build-arg URL=<URL> -t websphere-traditional:nd-prereq \
      -f Dockerfile.v855.prereq .
    ```

    This installs Installation Manager, WebSphere Application Server (and fix pack) and IBM Java. The `USER` and `GROUP` build arguments specify the OS user and group to create for the install. They are optional and, by default, are both set to `was`. The `URL` build argument is required and specifies the URL of the FTP or HTTP server directory where the binaries are hosted.

5. Run a container by using the prereq image to create the .tar file with the installed products in the current folder by using:

    ```bash
    docker run --rm -v $(pwd):/tmp websphere-traditional:nd-prereq
    ```

    Note: the user that the image is running as (UID 1) needs to have write access to the current directory.

6. Build the install image by using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> \
      -t websphere-traditional:nd-install -f Dockerfile.install .
    ```

    This unpacks the .tar file in to a clean image and copies the profile creation and startup script to the image. When the image is run, the profile is created and the server is started. The `USER` and `GROUP` build arguments must be given the same values specified when the prereq image was built.
