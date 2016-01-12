# Building an IBM WebSphere Application Server Classic Developer image from binaries

An IBM WebSphere Application Server Classic Developer image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [developerWorks](http://www.ibm.com/developerworks/downloads/ws/wasdevelopers/)
* IBM WebSphere Application Server Classic Developer binaries from [developerWorks](http://www.ibm.com/developerworks/downloads/ws/wasdevelopers

IBM WebSphere Application Server Classic Developer image is created using the following Dockerfiles

1. Dockerfile.prereq
2. Dockerfile.install
3. Dockerfile.profile ( Optionally used to create an image with profile )

Dockerfiles takes the values for the following variables during build time 

Dockerfile.prereq
* user(optional)[default 'was'] - user used for installation                                                                     
* group(optional)[default 'was'] - group the user belongs to
* URL(required) - URL from where the binaries are downloaded

Dockerfile.install
* user(optional)[default 'was'] - user used for installation                                                                     
* group(optional)[default 'was'] - group the user belongs to

Dockerfile.profile
* CELL_NAME(optional)[default 'DefaultCell01'] - cell name                                                                             
* NODE_NAME(optional)[default 'DefaultNode01'] - node name                                                                                      
* PROFILE_NAME(optional)[default 'AppSrv01'] - profile name                                                                            
* HOST_NAME(optional)[default 'localhost'] - host name    


Dockerfiles does the following:

Dockerfile.prereq:

1. Installs IBM Installation Manager
2. Installs IBM WebSphere Application Server 
3. Updates IBM WebSphere Application Server with the Fixpack
4. When the container is started a tar file of the IBM WebSphere Application Server Classic Base installation is created

Dockerfile.install:
                                                                                                           
1. Extracts the tar file created by Dockerfile.prereq
2. Copies the profile creation and startup script to the image
3. When the container is started , profile is created and the server is started

Dockerfile.profile:                                                                                  
                                                                                                                        
1. Uses the image created by Dockerfile.install as the base image                           
2. Copies the server startup script to the image                                
3. When the container is started the server is started      

## Building the IBM WebSphere Application Server Classic Base image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server Classic binaries on the FTP or HTTP server.
2. Clone this repository.
3. Move to the directory `websphere-classic/developer/`.
4. Build the prereq image using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group>  --build-arg URL=<URL> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

6. Run a container using the prereq image to get the tar file to the current folder using:

    ```bash
    docker run --rm -v $(pwd):/tmp <prereq-image-name>
    ```

7. Build the install image using:       

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```
    Use the install image name as `devinstall` if you are creating developer profile image 

7. Build the profile image using:                                                                                                 
                                                                                                                                       
    ```bash                                                                                                                            
    docker build --build-arg CELL_NAME=<cell-name> --build-arg NODE_NAME=<node-name> --build-arg PROFILE_NAME=<profile-name> --build-arg HOST_NAME=<host-name>  -t <profile-image-name> -f Dockerfile.profile .                              
    ``` 

## Running the images                                                                                                                           
                                                                                                                                                
* [Using the install image](Run-install-image.md)                                                                                               
* [Using the profile image](Run-profile-image.md)       

