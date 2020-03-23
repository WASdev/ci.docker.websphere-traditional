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

usage="Usage: build_installer.sh --username=<username> --password=<password> --im_url=<im url> [--os=<os> --arch=<arch>]"

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
    --arch=*)
      arch="${1#*=}"
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

this_arch="$(uname -m)"
case "${this_arch}" in
  ppc64el|ppc64le)
    this_arch=ppc64le;
    ;;
  s390x)
    this_arch=s390x;
    ;;
  amd64|x86_64)
    this_arch=x86_64;
    ;;
  *)
    echo "Unsupported arch: ${this_arch}";
    exit 1;
    ;;
esac

if [[ -z "${arch}" ]]
then
  arch=${this_arch}
  echo "Setting arch to ${arch}"
elif [[ "${arch}" == "all" ]]
then
  arch=""
  echo "Building for all architectures"
fi

if [[ ! "$im_url" =~ %ARCH% ]]
then
  if [[ ! "$im_url" =~ ${this_arch} ]]
  then
    echo "Error: the --im_url parameter should either be an installer for ${this_arch} or be a template containing %ARCH% that can be substituted"
    exit 1
  else
    im_url=${im_url//${this_arch}/%ARCH%}
  fi
fi

for current_arch in x86_64 ppc64le s390x; do
  if [[ -z "$arch" || "$current_arch" == "$arch" ]]
  then
    if [[ ! -f "agent.installer/agent.installer.${current_arch}.zip" ]]
    then
      IMURL=${im_url//%ARCH%/${current_arch}}
      wget -O "agent.installer/agent.installer.${current_arch}.zip" --no-verbose --progress=bar:force:noscroll --user "$username" --password "$password" $IMURL
      rc=$?
      if [ $rc -ne 0 ]
      then
        echo "FATAL: Error downloading agent-installer for $current_os, exiting"
        exit 2
      fi
    fi
    for current_os in ubuntu ubi ubi8; do
      if [[ -z "$os" || "$current_os" == "$os" ]]
      then
        docker build -t agent-installer:${current_arch}-${current_os} -f agent.installer/Dockerfile-${current_os} agent.installer --build-arg IMZIP=agent.installer.${current_arch}.zip
        if [[ "$current_arch" == "$this_arch" ]]
        then
          docker tag agent-installer:${current_arch}-${current_os} agent-installer:${current_os}
        fi
      fi
    done
  fi
done
