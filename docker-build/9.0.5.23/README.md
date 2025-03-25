# How to build this image

## Clone repo
`git clone git@github.com:WASdev/ci.docker.websphere-traditional.git`

`cd ci.docker.websphere-traditional/docker-build`

## Building the image

### Latest Fixpack

To create an image with the latest fixpack version of IBM Websphere Application Server (ILAN) V9.0 using your [IBMid](https://www.ibm.com/account/reg/us-en/signup?formid=urx-19776) and the IBM Installation Manager install kit download url (see [instructions](../download-iim.md) to get the download url).  

For example:
```
docker build -t websphere-traditional:9.0.5.23-ilan . \
    --build-arg IBMID={IBMid} \
    --build-arg IBMID_PWD={IBMid_password} \
    --build-arg IMURL={IBM_Installation_Manager_download_url}
```

### Specific version and/or Production use

To create an image with a specific fixpack version of IBM WebSphere Application Server, or for production use, you will also need to override the build arguments for PRODUCTID and REPO.

For example:
```
docker build -t websphere-traditional:9.0.5.23-base . \
    --build-arg IBMID={IBMid} \
    --build-arg IBMID_PWD={IBMid_password} \
    --build-arg IMURL={IBM_Installation_Manager_download_url} \
    --build-arg PRODUCTID=com.ibm.websphere.BASE.v90 \
    --build-arg REPO=https://www.ibm.com/software/repositorymanager/com.ibm.websphere.BASE.v90
```

### Latest Fixpack with recommended iFixes

To create an image with the latest fixpack version with all recommended iFixes, you will include the build-arg ```IFIXES=recommended```

For example:
```
docker build -t websphere-traditional:9.0.5.23-ilan . \
    --build-arg IBMID={IBMid} \
    --build-arg IBMID_PWD={IBMid_password} \
    --build-arg IMURL={IBM_Installation_Manager_download_url} \
    --build-arg IFIXES=recommended
```

## License

The Dockerfiles and associated scripts are licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

License for the product installed within the image is as follows:

* IBM WebSphere Application Server (ILAN) V9.0 under the [License Agreement for Non-Warranted Programs](http://www14.software.ibm.com/cgi-bin/weblap/lap.pl?la_formnum=&li_formnum=L-CTUR-B3SGXC)
* IBM WebSphere Application Server V9.0 under the ["Try & Buy" license](http://www14.software.ibm.com/cgi-bin/weblap/lap.pl?la_formnum=&li_formnum=L-CTUR-B3DL7L)


