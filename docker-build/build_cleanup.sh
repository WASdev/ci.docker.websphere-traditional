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


MYARCH="$(uname -m)"
case "${MYARCH}" in
  ppc64el|ppc64le)
    MYARCH=ppc64le;
    ;;
  s390x)
    MYARCH=s390x;
    ;;
  amd64|x86_64)
    MYARCH=x86_64;
    ;;
  *)
    echo "Unsupported arch: ${MYARCH}";
    exit 1;
    ;;
esac

PLATFORMS="ubuntu ubi ubi8"
TAGBASES="websphere-traditional sample-app"
VERSIONS="8.5.5.17 8.5.5.18 9.0.5.1 9.0.5.2 9.0.5.3 9.0.5.4"

for PLATFORM in $PLATFORMS; do
  docker rmi agent-installer:$PLATFORM agent-installer:$MYARCH-$PLATFORM
  for TAGBASE in $TAGBASES; do
    for VERSION in $VERSIONS; do
      docker rmi $TAGBASE:$VERSION-$PLATFORM
    done
  done
done
