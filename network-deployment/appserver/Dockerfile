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

FROM nd

MAINTAINER Kavitha Suresh Kumar <kavisuresh@in.ibm.com>

ARG PROFILE_NAME=AppSrv01

ARG CELL_NAME=ServerCell

ARG NODE_NAME=ServerNode

ARG HOST_NAME=localhost

# Create default AppServer profile
RUN /opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -templatePath \
    /opt/IBM/WebSphere/AppServer/profileTemplates/default -profileName $PROFILE_NAME -profilePath \
    /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME -cellName $CELL_NAME -nodeName $NODE_NAME -hostName $HOST_NAME

#Expose the ports 
EXPOSE 9060 9043 9080 9443 2809 5060 5061 8880 9633 9401 9403 9402 9100 9353 7276 7286 5558 5578 11003 11004

ENV PATH /opt/IBM/WebSphere/AppServer/bin:$PATH

COPY *.sh *.py /work/

CMD ["/work/updateHostAndFederateServer.sh"]
