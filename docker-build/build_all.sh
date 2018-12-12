#!/bin/bash
#
###########################################################################
# (C) Copyright IBM Corporation 2016.                                     #
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

if [ $# != 3 ]; then
  echo "Usage: build_all <IBMid> <IBMid password> <IM download url>"
  exit 1
fi

IBMID=$1
IBM_PASSWORD=$2
IM_URL=$3

for FILE in *; do
    if [ -d "$FILE" ]; then
      cd "$FILE"
      ./build $IBMID $IBM_PASSWORD "$IM_URL"
    fi
done
