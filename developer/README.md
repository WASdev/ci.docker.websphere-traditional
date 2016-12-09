# Building an IBM WebSphere Application Server traditional for Developers image

The files in this directory are used to build the `ibmcom/websphere-traditional` images on [Docker Hub](https://hub.docker.com/r/ibmcom/websphere-traditional/). These images contain the ILAN licensed IBM WebSphere Application Server traditional for Developers.

## Pre-requisites

If you wish to build these images for yourself you will need to obtain:
* An [IBMid](http://www.ibm.com/account/us-en/signup/register.html)
* An [IBM InstallationManager](http://www-01.ibm.com/support/docview.wss?uid=swg27025142) install .zip for x86 64-bit Linux (agent.installer.linux.gtk.x86_64_*.zip)

## Building the images

The images can be built as follows:

1. Clone this repository
2. Change to the directory `developer/`
3. Place the Installation Manager .zip file in the `im` directory.
4. Build the `websphere-traditional:install` and `websphere-traditional:profile` images by running:

    ```bash
    ./build <version> <IBMid> <IBMid password>
    ```
  where `<version>` is the required WebSphere Application Server fix-pack (e.g. `9.0.0.0`). The build will take some time as it is downloading the install binaries.

The build script can be modified to pass the following optional values via the `--build-arg` argument on `docker build`.

For `websphere-traditional:install`:
* `USER` (optional, default is `was`) - user used for the installation
* `GROUP` (optional, default is `was`) - group the user belongs to

For `websphere-traditional:profile`:
* `CELL_NAME` (optional, default is `DefaultCell01`) - cell name
* `NODE_NAME` (optional, default is `DefaultNode01`) - node name
* `PROFILE_NAME` (optional, default is `AppSrv01`) - profile name
* `HOST_NAME` (optional, default is `localhost`) - host name
* `SERVER_NAME` (optional, default is `server1`) - server name
* `ADMIN_USER_NAME` (optional, default is `wsadmin`) - admin user name

## Running the images

* [Using the IBM WebSphere Application Server traditional for Developers install image](Run-install-image.md)
* [Using the IBM WebSphere Application Server traditional for Developers profile image](Run-profile-image.md)
