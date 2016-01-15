# Building and Testing images 

IBM WebSphere Application Server Classic images can be built and verified using the test scripts provided.

## Build and Test IBM WebSphere Application Server Classic for Developers and Base images

1. Clone this repository.
2. Move to the directory `test`.
3. Build and test image using:

    ```bash
    sh buildAndVerify.sh <image-name> <dockerfile-location> <URL>
    ```

Parameter values for building Classic Base images:

* image-name - `base:install` for building install images or `base:profile` for building profile images
* dockerfile-location - ../base
* URL - URL where the binaries are placed

Parameter values for building Classic Developer images:

* image-name - `dev:install` for building install images or `dev:profile` for building profile images
* dockerfile-location - ../developer
* URL - URL where the binaries are placed

## Build and Test IBM WebSphere Application Server Classic Network Deployment images

1. Clone this repository.
2. Move to the directory `test`.
3. Build and test image using:

    ```bash
    sh buildAndVerifyND.sh <image-name> <dockerfile-location> <URL>
    ```

Parameter values for building Classic Base images:

* image-name - `nd`
* dockerfile-location - ../network-deployment
* URL - URL where the binaries are placed
