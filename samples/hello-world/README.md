# Hello World

A simple `Hello World` application that demonstrate a basic pattern for deploying an application into IBM Cloud Private using the official helm chart for IBM WebSphere Application Server traditional Base edition.

## Building the application image
Dockerfile adds three things to build application image
1. application EAR file
2. application installation script (Jython)
3. sample properties file that increases container thread pool to 100

Run following command inside this directory:

`docker build -t app .`

## Pushing the image to the private image registry

Push the built image to the private image registry of IBM Cloud Private. See [Pushing and pulling images](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.1/manage_images/using_docker_cli.html).

1. Log in to your private image registry.

    `docker login <cluster_CA_domain>:8500`

    `<cluster_CA_domain>` is the certificate authority (CA) domain that was set in the `config.yaml` file during installation. If you did not specify a CA domain name, the default value is `mycluster.icp`.

2. Tag the image.

    `docker tag app:hello-world <cluster_CA_domain>:8500/samples/app:hello-world`

3. Push the image to the private image registry.

    `docker push <cluster_CA_domain>:8500/samples/app:hello-world`

## Deploying the application into IBM Cloud Private using Helm chart

Helm is a package manager for Kubernetes. Charts being the terminology that helm use for package of configured Kubernetes resources. These charts allow you to create repeatable builds of an application. Helm provides several advantages. You can deploy all resources for an application with a single command. You can manage configuration settings and manifest format separately, and you can easily upgrade, rollback, or delete running processes.

The official helm chart for IBM WebSphere Application Server traditional Base edition is available in the [IBM/charts repository](https://github.com/IBM/charts/tree/master/stable/ibm-websphere-traditional)

1. Setup the Helm command line interface (CLI), if you haven't already, to deploy the application into IBM Cloud Private cluster. See [Setting up the Helm CLI](https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.1/app_center/create_helm_cli.html).

2. Navigate to the `deploy` directory in the terminal.

3. The `config-map.yaml` specifies a [ConfigMap](https://github.com/IBM/charts/tree/master/stable/ibm-websphere-traditional#configure-environment-using-configuration-properties) to configure your WebSphere Application Server traditional environment at deployment time. In this example, the initial heap size of JVM is changed and a sytem property called `my.system.prop` is set.

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: my-config-properties
    data:
      jvm.props: |-
        ResourceType=JavaVirtualMachine
        ImplementingResourceType=Server
        ResourceId=Cell=!{cellName}:Node=!{nodeName}:Server=!{serverName}:JavaProcessDef=:JavaVirtualMachine=
        AttributeInfo=jvmEntries
        initialHeapSize=2048

        # Header JVM System properties
        ResourceType=JavaVirtualMachine
        ImplementingResourceType=Server
        ResourceId=Cell=!{cellName}:Node=!{nodeName}:Server=!{serverName}:JavaProcessDef=:JavaVirtualMachine=
        AttributeInfo=systemProperties(name,value)
        #Properties
        my.system.prop=hello
    ```

    Create the ConfigMap by running:

    `kubectl apply -f config-map.yaml`

    We'll specify the name of this ConfigMap when deploying the helm chart later.

4. The `hello-world-values.yaml` overrides the default [configurations](https://github.com/IBM/charts/tree/master/stable/ibm-websphere-traditional#configuration) of the helm chart:

    ```yaml
    image:
      repository: <cluster_CA_domain>:8500/samples/app # Specify your cluster CA domain here
      tag: hello-world

    ingress:
      enabled: true
      path: /demo/
      rewriteTarget: /HelloWorld/hello

    configProperties:
      configMapName: my-config-properties
    ```

    - `image` parameter specifies the Docker image to deploy. Use the image we earlier pushed into the private image registry. Replace `<cluster_CA_domain>` with the the right CA domain for your cluster.
    - `ingress` parameter enables the [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/).
    - `configProperties` parameter refers to the ConfigMap from Step 3.

5. Add the Helm repo that contains the helm chart:

    `helm repo add ibm-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable/`

6. Deploy the helm chart for IBM WebSphere Application Server traditional:

    `helm install ibm-charts/ibm-websphere-traditional -f hello-world-values.yaml -n hello-world --namespace samples --tls`

7. Run the commands from the `NOTES` section (at the bottom of the output from running above command) to get the URL to the deployed application:

    ```bash
    export INGRESS_IP=$(kubectl get nodes -l proxy=true -o jsonpath="{.items[0].status.addresses[?(@.type==\"Hostname\")].address}")
    export APP_PATH=/demo/
    echo https://$INGRESS_IP$APP_PATH
    ```

8. Get the status of deployment by running:

    `kubectl get deployments`

    You should see an output similar to the following:

    ```
    NAME                       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE

    hello-world-ibm-webspher   1         1         1            1           2m
    ```

    Wait till the value under `AVAILABLE` column changes to `1`, which indicates that the pod is available. Run the command again to see updated value, if necessary.

9. Access the application using the URL obtained in step 7. You'll see the following output from the application:

    ```
    Hello World!
    ```

10. Congratulations! You've successfully deployed your application to IBM Cloud Private.

