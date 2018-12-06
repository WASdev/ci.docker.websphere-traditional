# Hello World

A simple `Hello World` application that demonstrate a basic pattern for deploying an application into IBM Cloud Private using the official helm chart.

## Building the application image
Dockerfile adds three things to build application image
1. applicaiton EAR file
2. application installation script (Jython)
3. sample properties file that increases container thread pool to 100

Run following command inside this directory:

`docker build -t app .`

## Deploying the application into IBM Cloud Private using a Helm chart

TODO-steps
