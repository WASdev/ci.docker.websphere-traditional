# Batch (Compute Grid)

A simple `Hello World` application that 

## Building the application image
Dockerfile adds three things to build application image
1. application EAR file
2. application installation script (Jython)
3. sample properties file that increases container thread pool to 100

Run following command inside this directory:

`docker build -t app .`

## Running the application
