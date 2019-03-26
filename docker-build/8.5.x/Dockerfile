############################################################################
# (C) Copyright IBM Corporation 2015, 2019                                #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  #
#                                                                          #
#      http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                          #
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
# See the License for the specific language governing permissions and      #
# limitations under the License.                                           #
#                                                                          #
############################################################################

FROM ubuntu:16.04

LABEL maintainer="Arthur De Magalhaes <arthurdm@ca.ibm.com>" \
      BuildLabel="$BUILDLABEL"

RUN apt-get update && apt-get install -y openssl wget unzip

ARG IMURL
ARG IBMID
ARG IBMID_PWD
ARG BUILDLABEL=none
ARG IFIXES=none

ARG PRODUCTID=com.ibm.websphere.DEVELOPERSILAN.v85
ARG REPO=http://www.ibm.com/software/repositorymanager/com.ibm.websphere.DEVELOPERSILAN.v85

ARG USER=was
ARG GROUP=was

ARG PROFILE_NAME=AppSrv01
ARG CELL_NAME=DefaultCell01
ARG NODE_NAME=DefaultNode01
ARG HOST_NAME=localhost
ARG SERVER_NAME=server1
ARG ADMIN_USER_NAME=wsadmin

COPY scripts/ /work/
COPY licenses /licenses/

RUN groupadd $GROUP \
  && useradd $USER -g $GROUP -m \
  && mkdir /opt/IBM \
  && chmod -R +x /work/* \
  && mkdir /etc/websphere \
  && mkdir /work/config \
  && chown -R $USER:$GROUP /work /opt/IBM /etc/websphere 


USER $USER

RUN cd /work && wget $IMURL \
  && unzip -q agent.installer.linux.gtk.x86_64*.zip -d /work/InstallationManagerKit \
  && rm -rf agent.installer.linux.gtk.x86_64*.zip \
  && echo "your_secureStore_password" > /tmp/secureStorePwd \
  && /work/InstallationManagerKit/tools/imutilsc saveCredential \
    -userName $IBMID -userPassword $IBMID_PWD \
    -secureStorageFile /tmp/secureStore \
    -masterPasswordFile /tmp/secureStorePwd \
    -url $REPO -verbose \
  && /work/InstallationManagerKit/tools/imcl install \
    $PRODUCTID \
    -acceptLicense -accessRights nonAdmin -showProgress \
    -installationDirectory /opt/IBM/WebSphere/AppServer -repositories $REPO \
    -installFixes $IFIXES -sRD /opt/IBM/WebSphere/AppServerIMShared \
    -dataLocation /opt/IBM/WebSphere/AppServerIMData \
    -secureStorageFile /tmp/secureStore -masterPasswordFile /tmp/secureStorePwd \
    -preferences offering.service.repositories.areUsed=false,\
com.ibm.cic.common.core.preferences.searchForUpdates=true,\
com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false,\
com.ibm.cic.common.core.preferences.keepFetchedFiles=false \
  && rm -Rf /tmp/secureStorePwd /tmp/secureStore /work/InstallationManagerKit

ENV PATH=/opt/IBM/WebSphere/AppServer/bin:$PATH \
    PROFILE_NAME=$PROFILE_NAME \
    SERVER_NAME=$SERVER_NAME \
    ADMIN_USER_NAME=$ADMIN_USER_NAME \
    EXTRACT_PORT_FROM_HOST_HEADER=true

RUN /work/create_profile.sh

USER root
RUN ln -s /opt/IBM/WebSphere/AppServer/profiles/${PROFILE_NAME}/logs /logs && chown $USER:$GROUP /logs
USER $USER

CMD ["/work/start_server.sh"]
