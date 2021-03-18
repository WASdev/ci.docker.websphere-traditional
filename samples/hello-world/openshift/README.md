## Using OpenShift Pipelines to build and deploy the hello-world sample

### Create a sandbox
mkdir demo

cd demo

### Clone this repo
git clone https://github.com/WASdev/ci.docker.websphere-traditional.git

cd ci.docker.websphere-traditional

cd samples/hello-world

### Use OCP console to get next command from Copy Login Command
oc login URI --token=TOKEN

### Create a new project
oc new-project hello-world-pipeline

### If the openshift-pipelines-operator isn't installed subscribe to it
oc apply -f openshift/subscription.yaml

### Install tasks, pipeline, storage and run
oc create -f openshift/pipeline
