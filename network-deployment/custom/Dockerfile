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

ARG PROFILE_NAME=Custom01
ARG CELL_NAME=CustomCell
ARG NODE_NAME=CustomNode
ARG HOST_NAME=localhost

# Create default Custom Node profile
RUN /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -templatePath \
    /opt/IBM/WebSphere/AppServer/profileTemplates/managed -profileName $PROFILE_NAME \
    -profilePath /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME -cellName $CELL_NAME \
    -nodeName $NODE_NAME -disableWASDesktopIntegration -FederateLater true -hostName $HOST_NAME

#Expose the ports
EXPOSE 2809 9402 9403 9353 9633 9100 11004 11003 9401 7276 7286 5558 5578 5060 5061 8880 9060 9043 9080 9443

ENV PATH /opt/IBM/WebSphere/AppServer/bin:$PATH

COPY *.sh *.py /work/

CMD ["/work/updateHostAndAddNode.sh"]
