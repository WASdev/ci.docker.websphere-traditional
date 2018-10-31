# How to build this image

To create an image with the latest fixpack version of IBM Websphere Application Server (ILAN) V9.0 using your [IBMid](https://www.ibm.com/account/reg/us-en/signup?formid=urx-19776) and the IBM Installation Manager install kit download url (see [instructions](download-iim.md) to get the download url).  

For example:
```
docker build -t websphere-traditional:9.0.0.9-ilan . \
    --build-arg IBMID={IBMid} \
    --build-arg IBMID_PWD={IBMid_password} \
    --build-arg IMURL={IBM_Installation_Manager_download_url}
```

To create an image with the latest fixpack version of IBM WebSphere Application Server V9.0, you will also need to override the build arguments for PRODUCTID and REPO.

For example:
```
docker build -t websphere-traditional:9.0.0.9-base . \
    --build-arg IBMID={IBMid} \
    --build-arg IBMID_PWD={IBMid_password} \
    --build-arg IMURL={IBM_Installation_Manager_download_url} \
    --build-arg PRODUCTID=com.ibm.websphere.BASE.v90 \
    --build-arg REPO=https://www.ibm.com/software/repositorymanager/com.ibm.websphere.BASE.v90
```

To create an image with the lastes fixack version with all recommended iFixes, you will include the build-arg ```IFIXES=recommended```

For example:
```
docker build -t websphere-traditional:9.0.0.9-ilan . \
    --build-arg IBMID={IBMid} \
    --build-arg IBMID_PWD={IBMid_password} \
    --build-arg IMURL={IBM_Installation_Manager_download_url} \
    --build-arg IFIXES=recommended
```

# How to run this image

When the container is started by using the IBM WebSphere Application Server traditional for Developers profile image, it takes the following environment variables:

* `UPDATE_HOSTNAME` (optional, set to `true` if the hostname should be updated from the default of `localhost`)
* `PROFILE_NAME` (optional, default is `AppSrv01`)
* `NODE_NAME` (optional, default is `DefaultNode01`)
* `SERVER_NAME` (optional, default is `server1`)

## Running the image by using the default values
  
```bash
   docker run --name was-server -h was-server -p 9043:9043 -p 9443:9443 -d \
   websphere-traditional:9.0.9.9-ilan
```

## Running the image by passing values for the environment variables

```bash
docker run --name <container-name> -h <container-name> \
  -e UPDATE_HOSTNAME=true -e PROFILE_NAME=<profile-name> \
  -e NODE_NAME=<node-name> -e SERVER_NAME=<server-name> \
  -p 9043:9043 -p 9443:9443 -d <profile-image-name>
```    

Example:

```bash
docker run --name test -h test -e UPDATE_HOSTNAME=true \
  -e PROFILE_NAME=AppSrv02 -e NODE_NAME=DefaultNode02 -e SERVER_NAME=server2 \
  -p 9043:9043 -p 9443:9443 -d websphere-traditional:profile 
``` 

## Retrieving the password

The admin console user id is default to ```wsadmin``` and the initial wsadmin user password is
in ```/tmp/PASSWORD```
```
   docker exec was-server cat /tmp/PASSWORD
```

## How to check the WebSphere Application Server installed level and ifixes

```
   docker run websphere-traditional:9.0.0.9-ilan versionInfo.sh -ifixes
```

## Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

Example:

```bash
docker logs -f --tail=all test
``` 

## Stopping the Application Server gracefully

```bash
docker stop --time=<timeout> <container-name>
```

Example:

```bash
docker stop --time=60 test
```

## License

The Dockerfiles and associated scripts are licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

License for the product installed within the image is as follows:

* IBM WebSphere Application Server (ILAN) V9.0 under the [License Agreement for Non-Warranted Programs](http://www14.software.ibm.com/cgi-bin/weblap/lap.pl?la_formnum=&li_formnum=L-CTUR-B3SGXC)
* IBM WebSphere Application Server V9.0 under the ["Try & Buy" license](http://www14.software.ibm.com/cgi-bin/weblap/lap.pl?la_formnum=&li_formnum=L-CTUR-B3DL7L)

