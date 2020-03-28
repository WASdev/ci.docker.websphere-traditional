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

docker image rm websphere-traditional:8.5.5.17-ubi8 \
                websphere-traditional:9.0.5.1-ubuntu \
                websphere-traditional:9.0.5.1-ubi \
                websphere-traditional:9.0.5.2-ubuntu \
                websphere-traditional:9.0.5.2-ubi \
                websphere-traditional:9.0.5.2-ubi8 \
                websphere-traditional:9.0.5.3-ubuntu \
                websphere-traditional:9.0.5.3-ubi8 \
                agent-installer:x86_64-ubuntu \
                agent-installer:x86_64-ubi \
                agent-installer:x86_64-ubi8 \
                agent-installer:ubuntu \
                agent-installer:ubi \
                agent-installer:ubi8
