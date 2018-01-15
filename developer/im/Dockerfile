#!/bin/bash
#
###########################################################################
# (C) Copyright IBM Corporation 2015, 2016.                               #
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

FROM ubuntu:16.04

RUN apt-get update && apt-get install -y unzip

# Install IBM Installation Manager

COPY agent.installer.linux.gtk.x86_64_*.zip /tmp/
RUN unzip -qd /tmp/im /tmp/agent.installer.linux.gtk.x86_64_*.zip \
  && /tmp/im/installc -acceptLicense -accessRights nonAdmin \
    -installationDirectory "/opt/IBM/InstallationManager"  \
    -dataLocation "/var/ibm/InstallationManager" -showProgress \
  && rm -rf /tmp/agent.installer.linux.gtk.x86_65_*.zip /tmp/im

ENV PATH /opt/IBM/InstallationManager/eclipse/tools:$PATH
