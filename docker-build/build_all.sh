#!/bin/bash
#
###########################################################################
# (C) Copyright IBM Corporation 2016, 2020.                               #
#                                                                         #
# Licensed under the Apache License, Version 2.0 (the "License");         #
# you may not use this file except in compliance with the License.        #
# You may obtain a copy of the License at                                 #
#                                                                         #
#      http://www.apache.org/licenses/LICENSE-2.0                         #
#                                                                         #
# Unless required by applicable law or agreed to in writing, software     #
# distributed under the License is distributed on an "AS IS" BASIS,       #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
# See the License for the specific language governing permissions and     #
# limitations under the License.                                          #
###########################################################################

# Executing this script builds all versions of the websphere-traditional Docker images.

pushd `dirname $0` > /dev/null && SCRIPTPATH=`pwd` && popd > /dev/null

cd $SCRIPTPATH || exit

usage="Usage: build_all.sh --username=<username> --password=<password> [ --repo=<repo> --productid=<productid> --buildlabel=<buildlabel> --dir=<dir> --tag=<tag> --os=<os> ]"

# parse in the arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --username=*)
      username="${1#*=}"
      ;;
    --password=*)
      password="${1#*=}"
      ;;
    --repo=*)
      repo="${1#*=}"
      ;;
    --productid=*)
      productid="${1#*=}"
      ;;
    --buildlabel=*)
      buildlabel="${1#*=}"
      ;;
    --dir=*)
      dir="${1#*=}"
      ;;
    --tag=*)
      tag="${1#*=}"
      ;;
    --os=*)
      os="${1#*=}"
      ;;
    --skiptests=*)
      buildtests=runtests="${1#*=}"
      ;;
    --buildtests=*)
      buildtests="${1#*=}"
      ;;
    --runtests=*)
      runtests="${1#*=}"
      ;;
    *)
      echo "Error: Invalid argument - $1"
      echo "$usage"
      exit 1
  esac
  shift
done

if [ -z "$username" ] || [ -z "$password" ]
then
  echo "Error: must provide --username and --password arguments"
  echo "$usage"
  exit 1
fi

arch="$(uname -m)"
case "${arch}" in
  ppc64el|ppc64le)
    arch=ppc64le;
    ;;
  s390x)
    arch=s390x;
    ;;
  amd64|x86_64)
    arch=amd64;
    ;;
  *)
    echo "Unsupported arch: ${arch}";
    exit 1;
    ;;
esac

failures=0

for current_dir in *; do
  if test -f "$current_dir/Dockerfile-ubi8" && ( ( test -z "$dir" && [[ ! "$current_dir" =~ x$ ]] ) || test "$dir" == "$current_dir" )
  then
    for current_os in ubi8; do
      if [[ -z "$os" || "$current_os" == "$os" ]]
      then
	      if [[ -f "${current_dir}/Dockerfile-${current_os}-${arch}" ]]
        then
          DOCKERFILE="${current_dir}/Dockerfile-${current_os}-${arch}"
        else
          DOCKERFILE="${current_dir}/Dockerfile-${current_os}"
        fi
        if [ ! -f "$DOCKERFILE" ]
        then
          echo "Not building ${current_os} because $DOCKERFILE does not exist."
          continue
        fi
        if [[ ! -z "$tag" ]]
        then
          IMAGE="${tag}-${current_os}"
        else
          IMAGE="${current_dir}-${current_os}"
        fi
        echo "---------- START Building websphere-traditional:$IMAGE ----------"
        buildCommand="docker build -t websphere-traditional:${IMAGE} -f ${DOCKERFILE} ${current_dir} --build-arg IBMID=\"$username\" --build-arg IBMID_PWD=\"$password\""
        if [ ! -z "$repo" ]
        then 
          buildCommand="$buildCommand --build-arg REPO=\"$repo\""
        fi
        if [ ! -z "$productid" ]
        then 
          buildCommand="$buildCommand --build-arg PRODUCTID=\"$productid\""
        fi
        if [ ! -z "$buildlabel" ]
        then 
          buildCommand="$buildCommand --build-arg BUILDLABEL=\"$buildlabel\""
        fi
        scrubbedBuildCommand="${buildCommand//$password/xxxxxxxx}"
        echo "BUILD COMMAND: $scrubbedBuildCommand"
        eval $buildCommand
        rc=$?
        if [ $rc -ne 0 ]
        then
          echo "FATAL: Error building websphere-traditional:$IMAGE, exiting"
          failures=$(expr $failures + 1)
          continue
        fi
        echo "---------- END Building websphere-traditional:$IMAGE ----------"
        if [[ -z "$skiptests" || "$skiptests" == "false" ]]
        then
          echo "---------- START Building websphere-traditional/sample-app:$IMAGE ----------"
          docker tag websphere-traditional:$IMAGE ibmcom/websphere-traditional:latest
          docker build -t websphere-traditional/sample-app:${IMAGE} ../samples/hello-world
          rc=$?
          docker rmi ibmcom/websphere-traditional:latest
          if [ $rc -ne 0 ]
          then
            echo "FATAL: Error building websphere-traditional/sample-app:$IMAGE, exiting"
            failures=$(expr $failures + 1)
            continue
          fi
          echo "---------- END Building websphere-traditional/sample-app:$IMAGE ----------"
          echo "---------- START Running websphere-traditional/sample-app:$IMAGE ----------"
          containerID="$(docker run --detach --rm -p 9080:9080 websphere-traditional/sample-app:$IMAGE)"
          sleep 10
          while [[ ! -z "$(docker container stats --no-stream ${containerID})" ]]
          do
            docker logs ${containerID} | grep -s "WSVR0001I" > /dev/null
            if [[ $? -eq 0 ]]
            then
              echo "Server is open for e-business"
              break
            fi
            sleep 2
          done
          response=$(curl http://localhost:9080/HelloWorld/hello)
          docker stop -t 20 ${containerID}
          if [[ "${response}" == "Hello World!" ]]
          then
            echo "Passed: ${response}"
          else
            if [[ -z "$response" ]]
            then
              echo "Failed"
            else
              echo "Failed: ${response}"
            fi
            failures=$(expr $failures + 1)
            continue
          fi
          echo "---------- END Running websphere-traditional/sample-app:$IMAGE ----------"
        fi
      fi
    done
  fi
done

exit $failures
