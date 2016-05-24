# Building an IBM WebSphere Application Server Base traditional V8.5.5 image from binaries

An IBM WebSphere Application Server Base traditional image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)

  IBM Installation Manager binaries:
  * Install_Mgr_v1.6.2_Lnx_WASv8.5.5.zip(CIK2GML)

* IBM WebSphere Application Server Base traditional binaries from [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) / [Fix Central](http://www-933.ibm.com/support/fixcentral/)

  IBM WebSphere Application Server Base traditional V8.5.5 binaries:
  * WAS_V8.5.5_1_OF_3.zip(CIK1QML)
  * WAS_V8.5.5_2_OF_3.zip(CIK1RML)
  * WAS_V8.5.5_3_OF_3.zip(CIK1SML)

  Fixpack V8.5.5.9 binaries:
  * 8.5.5-WS-WAS-FP0000009-part1.zip
  * 8.5.5-WS-WAS-FP0000009-part2.zip
  
IBM WebSphere Application Server Base traditional image is created by using the following Dockerfiles, multiple Dockerfiles are used to reduce the final image size:

1. [Dockerfile.prereq](Dockerfile.prereq)
2. [Dockerfile.install](Dockerfile.install)
3. [Dockerfile.profile](Dockerfile.profile) (Optional, use to create an image with a profile) 

The Dockerfiles take values for the following variables at build time: 

Dockerfile.prereq
* user (optional, default is 'was') - user used for the installation                                                               
* group (optional, default is 'was') - group the user belongs to
* URL (required) - URL from where the binaries are downloaded

Dockerfile.install
* user (optional, default is 'was') - user used for the installation                                                                     
* group (optional, default is 'was') - group the user belongs to

Dockerfile.profile
* CELL_NAME (optional, default is 'DefaultCell01') - cell name                                                                             
* NODE_NAME (optional, default is 'DefaultNode01') - node name                                                                                      
* PROFILE_NAME (optional, default is 'AppSrv01') - profile name                                                                            
* HOST_NAME (optional, default is 'localhost') - host name    


Dockerfiles take the following actions:

Dockerfile.prereq:

1. Installs IBM Installation Manager
2. Installs IBM WebSphere Application Server 
3. Updates IBM WebSphere Application Server with the Fixpack
4. When the container is started a .tar file for the IBM WebSphere Application Server Base traditional installation is created

Dockerfile.install:
                                                                                                           
1. Extracts the .tar file created by Dockerfile.prereq
2. Copies the profile creation and startup script to the image
3. When the container is started, the profile is created and the server is started

Dockerfile.profile:                                                                                  
                                                                                                                        
1. Uses the image created by Dockerfile.install as the base image                           
2. Copies the server startup script to the image                                
3. When the container is started the server is started      

## Building the IBM WebSphere Application Server Base traditional image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server traditional binaries on the FTP or HTTP server
2. Clone this repository
3. Move to the directory `base/`
4. Build the prereq image by using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> --build-arg URL=<URL> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

6. Run a container by using the prereq image to create the .tar file in the current folder by using:

    ```bash
    docker run --rm -v $(pwd):/tmp <prereq-image-name>
    ```

7. Build the base install image by using:       

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```
    Set the install image name as `baseinstall` if you are creating the base profile image. 

7. Build the base profile image by using:                                                                                                 
                                                                                                                                       
    ```bash                                                                                                                            
    docker build --build-arg CELL_NAME=<cell-name> --build-arg NODE_NAME=<node-name> --build-arg PROFILE_NAME=<profile-name> --build-arg HOST_NAME=<host-name> -t <profile-image-name> -f Dockerfile.profile .                              
    ``` 

## Running the images 
 
* [Using IBM WebSphere Application Server Base traditional install image](Run-install-image.md) 
* [Using IBM WebSphere Application Server Base traditional profile image](Run-profile-image.md)
