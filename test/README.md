# Building and Testing images 

IBM WebSphere Application Server Classic images can be built and verified using the test scripts provided.

## Build and test IBM WebSphere Application Server traditional for Developers images

1. [Build](../developer) the developer image
2. Run the verification script in this `test` directory:

    ```bash
    ./verify
    ```

## Build and test IBM WebSphere Application Server traditional base images

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

## Build and test IBM WebSphere Application Server traditional Network Deployment images

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
