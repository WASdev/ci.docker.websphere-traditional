## Running the IBM WebSphere Application Server traditional for Developers install image

When the container is started by using the IBM WebSphere Application Server traditional for Developers install image, it takes the following environment variables:

* `PROFILE_NAME` (optional, default is `AppSrv01`)
* `CELL_NAME` (optional, default is `DefaultCell01`)
* `NODE_NAME` (optional, default is `DefaultNode01`)
* `HOST_NAME` (optional, default is `localhost`)
* `SERVER_NAME` (optional, default is `server1`)
* `ADMIN_USER_NAME` (optional, default is `wsadmin`)

# Running the image by using the default values

```bash
docker run --name <container-name> -h <container-name> \
  -p 9043:9043 -p 9443:9443 -d <install-image-name>
```

Example:

```bash
docker run --name test -h test -p 9043:9043 -p 9443:9443 -d websphere-traditional:install
```

# Running the image by passing values for the environment variables

```bash
docker run --name <container-name> -h <container-name> \
  -e HOST_NAME=<container-name> -e PROFILE_NAME=<profile-name> \
  -e CELL_NAME=<cell-name> -e NODE_NAME=<node-name> \
  -e SERVER_NAME=<server-name> -p 9043:9043 -p 9443:9443 \
  -d <install-image-name>
```

Example:

```bash
docker run --name test -h test -e HOST_NAME=test \
  -e PROFILE_NAME=AppSrv02 -e CELL_NAME=DefaultCell02 \
  -e NODE_NAME=DefaultNode02 -e SERVER_NAME=server2 -p 9043:9043 -p 9443:9443 \
  -e ADMIN_USER_NAME=admin -d websphere-traditional:install
```

# Checking the logs

```bash
docker logs -f --tail=all <container-name>
```

Example:

```bash
docker logs -f --tail=all test
```

# Stopping the Application Server gracefully

```bash
docker stop --time=<timeout> <container-name>
```

Example:

```bash
docker stop --time=60 test
```
