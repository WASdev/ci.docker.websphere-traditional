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

ARTIFACTORY_PREFIX=hyc-icpcontent-docker-local.artifactory.swg-devops.com
DOCKER_PREFIX=ibmcom

ARCHS="x86_64 amd64 ppc64le s390x"
PLATFORMS="ubuntu ubi ubi7 ubi8"
TAGBASES="websphere-traditional websphere-traditional/sample-app"
VERSIONS="8.5.5.17 8.5.5.18 9.0.5.1 9.0.5.2 9.0.5.3 9.0.5.4 latest"

for PLATFORM in $PLATFORMS; do
  docker rmi agent-installer:$PLATFORM 2>/dev/null
done
for TAGBASE in $TAGBASES; do
  for VERSION in $VERSIONS; do
    docker rmi $TAGBASE:$VERSION 2>/dev/null
    docker rmi $ARTIFACTORY_PREFIX/$TAGBASE:$VERSION-inprogress $ARTIFACTORY_PREFIX/$TAGBASE:$VERSION 2>/dev/null
    docker rmi $DOCKER_PREFIX/$TAGBASE:$VERSION 2>/dev/null
    for PLATFORM in $PLATFORMS; do
      docker rmi $TAGBASE:$VERSION-$PLATFORM 2>/dev/null
      docker rmi $ARTIFACTORY_PREFIX/$TAGBASE:$VERSION-$PLATFORM-inprogress $ARTIFACTORY_PREFIX/$TAGBASE:$VERSION-$PLATFORM 2>/dev/null
      docker rmi $DOCKER_PREFIX/$TAGBASE:$VERSION-$PLATFORM 2>/dev/null
      for ARCH in $ARCHS; do
        docker rmi $TAGBASE:$VERSION-$PLATFORM-$ARCH 2>/dev/null
        docker rmi $ARTIFACTORY_PREFIX/$TAGBASE:$VERSION-$PLATFORM-$ARCH-inprogress $ARTIFACTORY_PREFIX/$TAGBASE:$VERSION-$PLATFORM-$ARCH 2>/dev/null
        docker rmi $DOCKER_PREFIX/$TAGBASE:$VERSION-$PLATFORM-$ARCH 2>/dev/null
      done
    done
  done
done
