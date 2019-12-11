#!/bin/bash
############################################################################
# (C) Copyright IBM Corporation 2019                                       #
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

# Arguments:  none|recommended|all [REPO] [ID] [PWD]
# Arguments:  space_seperated_ifix_ids [REPO] [ID] [PWD]
# eg. /work/was_service recommended 
# eg. /work/was_service com.ibm.java.sdk.v8
# eg. /work/was_service 9.0.0.9-WAS-IFPH12345 
# eg. /work/was_service all http://myrepo.intranet.company.com/was90 


IMURL=$1 
IFIXES=$2 
REPO=$3 
IBMID=$4 
IBMID_PWD=$5

cd /work 
wget $IMURL
unzip agent.installer.linux.gtk.x86_64*.zip -d /work/InstallationManagerKit 
rm -rf agent.installer.linux.gtk.x86_64*.zip 

if [ $IBMID != "" ] ; then
    echo "your_secureStore_password" > /tmp/secureStorePwd
    /work/InstallationManagerKit/tools/imutilsc saveCredential \
      -userName $IBMID -userPassword $IBMID_PWD \
      -secureStorageFile /tmp/secureStore \
      -masterPasswordFile /tmp/secureStorePwd \
      -url $REPO
else 
    cp /work/secureStore /tmp/secureStore
    cp /work/secureStorePwd /tmp/secureStorePwd
fi

### TODO: need to grep com.ibm.websphere and ILAN or BASE or DEVELOPERS
PRODUCTIDS=`/work/InstallationManagerKit/tools/imcl listInstalledPackages \
    -dataLocation /opt/IBM/WebSphere/AppServerIMData -accessRights nonAdmin \
    | xargs echo` 

if [ "$IFIXES" == "none" ] || [ "$IFIXES" == "recommended" ] || [ "$IFIXES" == "all" ] ; then
    INSTALL_FIXES="-installFixes $IFIXES"
else 
    PRODUCTIDS="$PRODUCTIDS $IFIXES"
    INSTALL_FIXES=""
fi

/work/InstallationManagerKit/tools/imcl install \
    $PRODUCTIDS \
    -acceptLicense -accessRights nonAdmin -showProgress \
    -installationDirectory /opt/IBM/WebSphere/AppServer -repositories $REPO \
    $INSTALL_FIXES -sRD /opt/IBM/WebSphere/AppServerIMShared \
    -dataLocation /opt/IBM/WebSphere/AppServerIMData \
    -secureStorageFile /tmp/secureStore -masterPasswordFile /tmp/secureStorePwd \
    -preferences offering.service.repositories.areUsed=false,\
com.ibm.cic.common.core.preferences.searchForUpdates=true,\
com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false,\
com.ibm.cic.common.core.preferences.keepFetchedFiles=false

rm -Rf /tmp/secureStorePwd /tmp/secureStore /work/InstallationManagerKit


