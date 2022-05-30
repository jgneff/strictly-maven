#!/bin/sh
# maven.sh - starts the Apache Maven build tool
# Copyright 2021-2022 John Neffenger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
set -o errexit

# Checks for required environment variables
: "${SNAP:?}"
: "${SNAP_USER_COMMON:?}"

# Creates the Maven settings file if not present
if [ ! -e "$SNAP_USER_COMMON/settings.xml" ]; then
    cp "$SNAP/conf/settings.xml" "$SNAP_USER_COMMON/"
fi

# Uses the OpenJDK Snap, if connected, when JAVA_HOME is not set
if [ -z "$JAVA_HOME" ] && [ -d "$SNAP/jdk" ]; then
    export JAVA_HOME=$SNAP/jdk
fi

# Starts Maven
"$SNAP/maven/bin/mvn" --strict-checksums \
    --settings "$SNAP_USER_COMMON/settings.xml" "$@"
