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

# Executing this script downloads installer images and builds installer containers for all platforms.

pushd `dirname $0` > /dev/null && SCRIPTPATH=`pwd` && popd > /dev/null

cd $SCRIPTPATH || exit

usage="Usage: build_installer.sh --username=<username> --password=<password> --im_url=<im url> [ --os=<os> --download=(true|false) ]"

# parse in the arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --username=*)
      username="${1#*=}"
      ;;
    --password=*)
      password="${1#*=}"
      ;;
    --im_url=*)
      im_url="${1#*=}"
      ;;
    --os=*)
      os="${1#*=}"
      ;;
    --download=*)
      download="${1#*=}"
      ;;
    *)
      echo "Error: Invalid argument - $1"
      echo "$usage"
      exit 1
  esac
  shift
done

if [ -z "$username" ] || [ -z "$password" ] || [ -z "$im_url" ]
then
  echo "Error: must provide --username, --password, and --im_url arguments"
  echo "$usage"
  exit 1
fi

arch="$(uname -m)"
case "${arch}" in
  ppc64el|ppc64le)
    arch=ppc64le;
    docker_arch=ppc64le;
    ;;
  s390x)
    arch=s390x;
    docker_arch=s390x;
    ;;
  amd64|x86_64)
    arch=x86_64;
    docker_arch=amd64;
    ;;
  *)
    echo "Unsupported arch: ${arch}";
    exit 1;
    ;;
esac

if [[ "$im_url" =~ %ARCH% ]]
then
  im_url=${im_url//%ARCH%/${arch}}
elif [[ ! "$im_url" =~ ${arch} ]]
then
  echo "Error: the --im_url parameter should either be an installer for ${arch} or be a template containing %ARCH% that can be substituted"
  exit 1
fi

if [[ -z "$download" || "$download" != "false" || ! -f "agent.installer/agent.installer.${arch}.zip" ]]
then
  wget -O "agent.installer/agent.installer.${arch}.zip" --no-verbose --show-progress --progress=dot:giga --user "$username" --password "$password" $im_url
  rc=$?
  if [ $rc -ne 0 ]
  then
    echo "FATAL: Error downloading agent-installer for $arch, exiting"
    exit 2
  fi
fi
for current_os in ubuntu ubi7 ubi8; do
  if [[ -z "$os" || "$current_os" == "$os" ]]
  then
    if [[ -f "agent.installer/Dockerfile-${current_os}-${docker_arch}" ]]
    then
      DOCKERFILE="agent.installer/Dockerfile-${current_os}-${docker_arch}"
    else
      DOCKERFILE="agent.installer/Dockerfile-${current_os}"
    fi
    if [ ! -f "$DOCKERFILE" ]
    then
      echo "Not building ${current_os} because $DOCKERFILE does not exist."
      continue
    fi
    docker build -t agent-installer:${current_os} -f ${DOCKERFILE} agent.installer --build-arg IMZIP=agent.installer.${arch}.zip
  fi
done
