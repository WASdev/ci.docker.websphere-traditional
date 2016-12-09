# Building an IBM WebSphere Application Server traditional base image from binaries

The following instructions can be used to build an IBM WebSphere Application Server traditional base image from binaries for either V8.5.5 or V9.0.0.

## Binaries required for V8.5.5

* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)

  IBM Installation Manager binaries:
  * Install_Mgr_v1.6.2_Lnx_WASv8.5.5.zip (CIK2GML)

* IBM WebSphere Application Server Base traditional binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)

  IBM WebSphere Application Server Base traditional V8.5.5 binaries:
  * WAS_V8.5.5_1_OF_3.zip (CIK1QML)
  * WAS_V8.5.5_2_OF_3.zip (CIK1RML)
  * WAS_V8.5.5_3_OF_3.zip (CIK1SML)

  Fixpack V8.5.5.10 binaries:
  * 8.5.5-WS-WAS-FP0000010-part1.zip
  * 8.5.5-WS-WAS-FP0000010-part2.zip

  IBM WebSphere SDK Java Technology Edition V8.0.2.10 binaries:
  * 8.0.2.10-WS-IBMWASJAVA-Linux.zip

## Binaries required for V9.0.0

* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)

  IBM Installation Manager V1.8.5 for Linux x86_64 binaries:
  * agent.installer.lnx.gtk.x86_64_1.8.5.zip (CND0ZML)

* IBM WebSphere Application Server Base traditional binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)

  IBM WebSphere Application Server V9.0 binaries:
  * was.repo.9000.base.zip (CND1AML)

  Fixpack V9.0.0.1 binaries:
  * 9.0.0-WS-WAS-FP001.zip

  IBM SDK, Java (TM) Technology Edition, Version 8 for Linux binaries:
  * sdk.repo.8030.java8.linux.zip (CND18ML)

## Building the IBM WebSphere Application Server Base traditional image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server traditional binaries on an FTP or HTTP server
2. Clone this repository
3. Move to the directory `base`
4. Build the prereq image for V8.5.5:

    ```bash
    docker build --build-arg USER=<user> --build-arg GROUP=<group> \
      --build-arg URL=<URL> -t websphere-traditional:prereq \
      -f Dockerfile.v855.prereq .
    ```

    or for V9.0.0:

    ```bash
    docker build --build-arg USER=<user> --build-arg GROUP=<group> \
      --build-arg URL=<URL> -t websphere-traditional:prereq \
      -f Dockerfile.v9.prereq .
    ```

    This installs Installation Manager, WebSphere Application Server (and fix pack) and IBM Java. The `USER` and `GROUP` build arguments specify the OS user and group to create for the install. They are optional and, by default, are both set to `was`. The `URL` build argument is required and specifies the URL of the FTP or HTTP server directory where the binaries are hosted.

5. Run a container by using the prereq image to create the .tar file with the installed products in the current folder by using:

    ```bash
    docker run --rm -v $(pwd):/tmp websphere-traditional:prereq
    ```

    Note: the user that the image is running as (UID 1) needs to have write access to the current directory.

6. Build the install image by using:

    ```bash
    docker build --build-arg USER=<user> --build-arg GROUP=<group> \
      -t websphere-traditional:install -f Dockerfile.install .
    ```

    This unpacks the .tar file in to a clean image and copies the profile creation and startup script to the image. When the image is run, the profile is created and the server is started. The `USER` and `GROUP` build arguments must be given the same values specified when the prereq image was built.

7. Optionally, build an image with a profile created by using:

    ```bash
    docker build --build-arg CELL_NAME=<cell-name> \
      --build-arg NODE_NAME=<node-name> --build-arg PROFILE_NAME=<profile-name> \
      --build-arg HOST_NAME=<host-name> --build-arg SERVER_NAME=<server-name> \
      --build-arg ADMIN_USER_NAME=<admin-user-name> \
      -t websphere-traditional:profile -f Dockerfile.profile .
    ```

    This creates a profile in the image so that the servers starts immediately when the image is run. The build arguments are all optional and the default values can be found in [Dockerfile.profile](Dockerfile.profile).

## Running the images

* [Using the IBM WebSphere Application Server Base traditional install image](Run-install-image.md)
* [Using the IBM WebSphere Application Server Base traditional profile image](Run-profile-image.md)
