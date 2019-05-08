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

if [[ $# != 3 && $# != 4 ]]; then
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
  echo "Limiting build to the websphere-traditional:$VERSION image"
fi

for FILE in *; do
  if [[ ! "$FILE" =~ x$ ]] && [[ -f "$FILE/Dockerfile" ]] && [[ -z "$VERSION" || "$VERSION" == "$FILE" ]]
  then
    echo "---------- START Building websphere-traditional:$FILE ----------"
    docker build -t websphere-traditional:$FILE $FILE --build-arg IBMID="$IBMID" --build-arg IBMID_PWD="$IBMID_PWD" --build-arg IMURL="$IMURL"
    rc=$?
    if [ $rc -ne 0 ]
    then
      echo "FATAL: Error building websphere-traditional:$FILE, exiting"
      exit 2
    fi
    echo "---------- END Building websphere-traditional:$FILE ----------"
  fi
done

docker images
