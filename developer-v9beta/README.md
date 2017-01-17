# Building an IBM WebSphere Application Server traditional V9.0 Beta for Developers image from binaries

An IBM WebSphere Application Server traditional for Developers image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [developerWorks](http://www.ibm.com/developerworks/downloads/ws/wasdevelopers/)

  IBM Installation Manager binaries:
  * agent.installer.linux.gtk.x86_64_1.8.4001.20160217_1716.zip

IBM WebSphere Application Server traditional for Developers image is created by using the following Dockerfiles, multiple Dockerfiles are used to reduce the final image size:

1. [Dockerfile.prereq](Dockerfile.prereq)
2. [Dockerfile.install](Dockerfile.install)
3. [Dockerfile.profile](Dockerfile.profile) (Optional, use to create an image with a profile) 

The Dockerfiles take values for the following variables at build time:

Dockerfile.prereq
* user (optional, default is 'was') - user used for the installation
* group (optional, default is 'was') - group the user belongs to
* IBMIDUSER (required) - IBM ID User name for access to beta binaries
* IBMIDPWD (required) - IBM ID Password for access to beta binaries

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
4. When the container is started a .tar file of the IBM WebSphere Application Server traditional for Developers installation is created

Dockerfile.install:
                                                                                                           
1. Extracts the .tar file created by Dockerfile.prereq
2. Copies the profile creation and startup script to the image
3. When the container is started, the profile is created and the server is started

Dockerfile.profile:                                                                                  
                                                                                                                        
1. Uses the image created by Dockerfile.install as the base image                           
2. Copies the server startup script to the image                                
3. When the container is started the server is started      

## Building the IBM WebSphere Application Server traditional for Developers image

1. Clone this repository
2. Move to the directory `developer-v9beta/`
3. Place the downloaded IBM Installation Manager .zip file in this directory
4. Build the prereq image by using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group>  --build-arg IBMIDUSER=<IBMIDUSER> --build-arg IBMIDPWD=<IBMIDPWD> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

5. Run a container by using the prereq image to create the .tar file in the current folder by using:

    ```bash
    docker run --rm -v $(pwd):/tmp <prereq-image-name>
    ```

6. Build the install image by using:       

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```
    Set the install image name as `devinstall` if you are creating the developer profile image 

7. Build the profile image by using:                                                                                                 
                                                                                                                                       
    ```bash                                                                                                                            
    docker build --build-arg CELL_NAME=<cell-name> --build-arg NODE_NAME=<node-name> --build-arg PROFILE_NAME=<profile-name> --build-arg HOST_NAME=<host-name> -t <profile-image-name> -f Dockerfile.profile .                              
    ``` 

## Running the images                                                                                                                           
                                                                                                                                                
* [Using the IBM WebSphere Application Server traditional for Developers install image](../developer/Run-install-image.md)                                                                                               
* [Using the IBM WebSphere Application Server traditional for Developers profile image](../developer/Run-profile-image.md)       

