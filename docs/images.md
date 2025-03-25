
# IBM Container Registry (ICR)
WebSphere Application Server traditional [images](https://www.ibm.com/docs/en/was/9.0.5?topic=container-websphere-application-server-images) are available from the IBM Container Registry (ICR) at `icr.io/appcafe/websphere-traditional`. Our recommendation is to use ICR as it doesn't impose rate limits on image pulls. Images can be pulled from ICR without authentication.

The images for the latest 3 Websphere releases for 8.5.5.x and 9.0.5.x are available and are refreshed regularly (every 1-2 weeks) to include fixes for the operating system (OS). 8.5.5.x images are not available on the s390x platform. Images are based on UBI 8 standard and include IBM Java 8.

Available image tags are listed below.

The `latest` tag simplifies pulling the full latest Websphere 9.0.5 release. It is an alias for the `9.0.5.22` tag. If you do not specify a tag value, `latest` is used by default.

Append a tag to `icr.io/appcafe/websphere-traditional` to pull a specific image. For example: 
```
icr.io/appcafe/websphere-traditional:9.0.5.21
```

Available images can be listed using [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started). Log in with your IBMid prior to running the following commands. Note that authentication is only required to list the images. **Images can be pulled from ICR without authentication**: 
```
ibmcloud cr region-set global 
ibmcloud cr images --restrict appcafe/websphere-traditional
```

## Latest version (9.0.5.23)

```
9.0.5.23
latest
```

## 9.0.5.22

```
9.0.5.22
```

## 9.0.5.21

```
9.0.5.21
```

## 8.5.5.27

```
8.5.5.27
```

## 8.5.5.26

```
8.5.5.26
```

## 8.5.5.25

```
8.5.5.25
```