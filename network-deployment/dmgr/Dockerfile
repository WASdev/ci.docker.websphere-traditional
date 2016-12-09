###########################################################################
# (C) Copyright IBM Corporation 2015.                                     #
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

FROM websphere-traditional:nd-install

ARG PROFILE_NAME=Dmgr01
ARG CELL_NAME=DefaultCell01
ARG NODE_NAME=DefaultNode01
ARG HOST_NAME=localhost

# Create Deployment Manager profile
RUN /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -templatePath \
    /opt/IBM/WebSphere/AppServer/profileTemplates/management -profileName $PROFILE_NAME \
    -profilePath /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME  -serverType DEPLOYMENT_MANAGER \
    -cellName $CELL_NAME -nodeName $NODE_NAME -disableWASDesktopIntegration -hostName $HOST_NAME

EXPOSE 9060 9043 9809 8879 9632 9401 9403 9402 9100 7277 9352 5555 7060 11005 11006 9420

ENV PATH /opt/IBM/WebSphere/AppServer/bin:$PATH

RUN /opt/IBM/WebSphere/AppServer/bin/startManager.sh

COPY startDmgr.sh update*.py /work/

CMD ["/work/startDmgr.sh"]
