############################################################################
# (C) Copyright IBM Corporation 2018, 2019                                      #
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

FROM ibmcom/websphere-traditional:latest

LABEL maintainer="Scott Kurz <skurz@us.ibm.com>"

# Create Mailer (application) DB and populate with sample data
COPY --chown=was:root CreateMailerTablesDerby.ddl /work/ddl/mailer.ddl
#COPY --chown=was:root CreateSmallerMailerTablesDerby.ddl /work/ddl/mailer.ddl
RUN [ "/opt/IBM/WebSphere/AppServer/java/8.0/bin/java", "-Dij.database=jdbc:derby:/work/mailerdb;create=true" , \
   "-Djava.ext.dirs=/opt/IBM/WebSphere/AppServer/derby/lib", "org.apache.derby.tools.ij", \
   "/work/ddl/mailer.ddl" \
    ]

#
# Run admin scripts one-by-one
#

# 0. Copy to a different name so it doesn't get run with every invocation to configure.sh
COPY --chown=was:root was-config.props /work/config/config.props

# 1. Configure the job scheduler
COPY --chown=was:root scheduler.py /work/config/
RUN /work/configure.sh /work/config/scheduler.py

# 2. Enable application security (using the same wsadmin id as userid)
COPY --chown=was:root security.py /work/config/
RUN /work/configure.sh /work/config/security.py

# 3. Configure JVM args including enabling debug mode, configure startup service
RUN work/applyConfig.sh /work/config/config.props

# 4. Add HealthCenter properties
COPY --chown=was:root jvm.hc.props /work/config/jvm.hc.props
# --- HealthCenter output dir
RUN mkdir /work/hc
RUN work/applyConfig.sh /work/config/jvm.hc.props

# 5. Create working directory for application HFS output
RUN mkdir /work/batch-output

# 6. configure mailer application datasource
COPY --chown=was:root mailerDS.py /work/config/
RUN /work/configure.sh /work/config/mailerDS.py

# 7. Copy application EAR files
COPY --chown=was:root MailerSample.ear /work/app/
COPY --chown=was:root SimpleCIEar.ear /work/app/

# 8. Install the two batch sample applications
COPY --chown=was:root installApps.py /work/config/
RUN /work/configure.sh /work/config/installApps.py

# 9. Now copy job definitions (which may be more dynamic than the EAR artifacts)
COPY --chown=was:root Mailer.xml /work/xjcl/
COPY --chown=was:root SimpleCIxJCL.xml /work/xjcl/

