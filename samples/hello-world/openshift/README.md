## Example setup for using OpenShift Pipelines to build and deploy the hello-world sample

### Create a sandbox
mkdir demo

cd demo

### Clone this repo
git clone git@github.com:gmarcy/ci.docker.websphere-traditional.git

cd ci.docker.websphere-traditional

git checkout tekton-testing

(You can checkout from master here after I deliver this branch:
 git clone git@github.com:WASdev/ci.docker.websphere-traditional.git)

cd samples/hello-world

oc login URI --token=TOKEN (from Copy Login Command in OCP console>

### Create a new project
oc new-project hello-world-pipeline

### If the openshift-pipelines-operator isn't installed subscribe to it
oc apply -f pipeline/subscription.yaml

### Install tasks
oc create -f pipeline/update_deployment_task.yaml

oc create -f pipeline/apply_manifest_task.yaml

### Install pipeline
oc create -f pipeline/pipeline.yaml

### Install pipeline resources
oc create -f pipeline/resources.yaml

### A limitation was removed in the tektoncd buildah support
oc apply -f pipeline/buildah.yaml

### Start the pipeline
tkn pipeline start build-and-deploy
