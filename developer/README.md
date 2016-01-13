# Building an IBM WebSphere Application Server Classic v8.5.5 for Developers image from binaries

An IBM WebSphere Application Server Classic for Developers image can be built by obtaining the following binaries:
* IBM Installation Manager binaries from [developerWorks](http://www.ibm.com/developerworks/downloads/ws/wasdevelopers/)

  IBM Installation Manager binaries:
  * agent.installer.linux.gtk.x86_64_1.6.2000.20130301_2248.zip

* IBM WebSphere Application Server Classic for Developers binaries from [developerWorks](http://www.ibm.com/developerworks/downloads/ws/wasdevelopers

  IBM WebSphere Application Server Classic v8.5.5 for Developers binaries
  * was.repo.8550.developers.ilan_part1.zip
  * was.repo.8550.developers.ilan_part2.zip
  * was.repo.8550.developers.ilan_part3.zip

  Fixpack 8.5.5.8 binaries:
  * 8.5.5-WS-WAS-FP0000008-part1.zip
  * 8.5.5-WS-WAS-FP0000008-part2.zip

IBM WebSphere Application Server Classic for Developers image is created using the following Dockerfiles(multiple Dockerfiles are used to reduce the final image size):

1. [Dockerfile.prereq](Dockerfile.prereq)
2. [Dockerfile.install](Dockerfile.install)
3. [Dockerfile.profile](Dockerfile.profile)(Optionally used to create an image with profile )

The Dockerfiles take the values for the following variables during build time:

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


Dockerfiles perform the following actions:

Dockerfile.prereq:

1. Installs IBM Installation Manager
2. Installs IBM WebSphere Application Server 
3. Updates IBM WebSphere Application Server with the Fixpack
4. When the container is started a tar file of the IBM WebSphere Application Server Classic for Developers installation is created

Dockerfile.install:
                                                                                                           
1. Extracts the tar file created by Dockerfile.prereq
2. Copies the profile creation and startup script to the image
3. When the container is started, profile is created and the server is started

Dockerfile.profile:                                                                                  
                                                                                                                        
1. Uses the image created by Dockerfile.install as the base image                           
2. Copies the server startup script to the image                                
3. When the container is started the server is started      

## Building the IBM WebSphere Application Server Classic for Developers image

1. Place the downloaded IBM Installation Manager and IBM WebSphere Application Server Classic binaries on the FTP or HTTP server.
2. Clone this repository.
3. Move to the directory `developer/`.
4. Build the prereq image using:

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group>  --build-arg URL=<URL> -t <prereq-image-name> -f Dockerfile.prereq .
    ```

6. Run a container using the prereq image to create the tar file in the current folder using:

    ```bash
    docker run --rm -v $(pwd):/tmp <prereq-image-name>
    ```

7. Build the install image using:       

    ```bash
    docker build --build-arg user=<user> --build-arg group=<group> -t <install-image-name> -f Dockerfile.install .
    ```
    Set the install image name as `devinstall` if you are creating the developer profile image 

7. Build the profile image using:                                                                                                 
                                                                                                                                       
    ```bash                                                                                                                            
    docker build --build-arg CELL_NAME=<cell-name> --build-arg NODE_NAME=<node-name> --build-arg PROFILE_NAME=<profile-name> --build-arg HOST_NAME=<host-name> -t <profile-image-name> -f Dockerfile.profile .                              
    ``` 

## Running the images                                                                                                                           
                                                                                                                                                
* [Using the IBM WebSphere Application Server Classic for Developers install image](Run-install-image.md)                                                                                               
* [Using the IBM WebSphere Application Server Classic for Developers profile image](Run-profile-image.md)       

