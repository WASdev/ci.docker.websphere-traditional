#!/bin/bash
#
###########################################################################
# (C) Copyright IBM Corporation 2016, 2019.                               #
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

# Executing this script builds all released versions of the websphere-traditional Docker images.

if [[ $# != 3 && $# != 4 && $# != 5 ]]; then
  echo "Usage: build_all <IBMid> <IBMid password> <IM download url>"
  echo "  see download-iim.md for information on the IM download url"
  exit 1
fi

IBMID=$1
IBMID_PWD=$2
IMURL=$3
# optional 4th arg limits the build to a single version
if [[ ! -z "$4" ]]
then
  VERSION=$4
  echo "Limiting build to version $VERSION"
fi
# optional 5th arg limits the build to a single os
if [[ ! -z "$5" ]]
then
  OS=$5
  echo "Limiting build to OS $OS"
fi

for FILE in *; do
  if [[ ! "$FILE" =~ x$ ]] && [[ -f "$FILE/Dockerfile" ]] && [[ -z "$VERSION" || "$VERSION" == "$FILE" ]]
  then
    for CURRENTOS in ubuntu ubi ubi8; do
      if [[ -z "$OS" || "$CURRENTOS" == "$OS" ]]
      then
        IMAGE=$FILE
        DOCKERFILE="${FILE}/Dockerfile"

        # Update variables when building ubi
        if [[ "$CURRENTOS" == "ubi" ]]
        then
          if [ ! -f "${FILE}/Dockerfile.ubi" ]
          then
            echo "Not building ubi because ${FILE}/Dockerfile.ubi does not exist."
            continue
          fi
          IMAGE="${FILE}-ubi"
          DOCKERFILE="${FILE}/Dockerfile.ubi"
        fi

        # Update variables when building ubi8
        if [[ "$CURRENTOS" == "ubi8" ]]
        then
          if [ ! -f "${FILE}/Dockerfile.ubi8" ]
          then
            echo "Not building ubi8 because ${FILE}/Dockerfile.ubi8 does not exist."
            continue
          fi
          IMAGE="${FILE}-ubi8"
          DOCKERFILE="${FILE}/Dockerfile.ubi8"
        fi

        echo "---------- START Building websphere-traditional:$IMAGE ----------"
        docker build -t websphere-traditional:$IMAGE -f $DOCKERFILE $FILE --build-arg IBMID="$IBMID" --build-arg IBMID_PWD="$IBMID_PWD" --build-arg IMURL="$IMURL"
        rc=$?
        if [ $rc -ne 0 ]
        then
          echo "FATAL: Error building websphere-traditional:$FILE, exiting"
          exit 2
        fi
        echo "---------- END Building websphere-traditional:$FILE ----------"
      fi
    done
  fi
done

docker images
