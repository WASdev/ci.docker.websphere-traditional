# Building and Testing images 

IBM WebSphere Application Server Classic images can be built and verified using the test scripts provided.

## Build and Test image

1. Clone this repository.
2. Move to the directory `test`.
3. Build and Test image using:

    ```bash
    sh buildAndverify.sh <image-name> <dockerfile-location> <URL>`
    ```

Parameter values for building Classic Base images:

* image-name - base:install for building install images or base:profile for building profile images
* dockerfile-location - ../base
* URL - URL where the binaries are placed

Parameter values for building Classic Developer images:
                                                  
* image-name - developer:install for building install images or developer:profile for building profile images
* dockerfile-location - ../developer                   
* URL - URL where the binaries are placed

