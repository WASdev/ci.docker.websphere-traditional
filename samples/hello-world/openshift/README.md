## Using OpenShift Pipelines to build and deploy the hello-world sample

### Create a sandbox
mkdir demo

cd demo

### Clone this repo
git clone git@github.com:WASdev/ci.docker.websphere-traditional.git

cd ci.docker.websphere-traditional

git checkout openshift-pipelines

cd samples/hello-world

### Use OCP console to get next command from Copy Login Command
oc login URI --token=TOKEN

### Create a new project
oc new-project hello-world-pipeline

### If the openshift-pipelines-operator isn't installed subscribe to it
oc apply -f openshift/subscription.yaml

### We need to remove a limitation in the tektoncd buildah support to allow nested projects
oc apply -f openshift/buildah.yaml

### Install tasks, pipeline and resources
oc create -f openshift/pipeline

### Start the pipeline using OCP console or use CLI

#### CLI
tkn pipeline start build-and-deploy
