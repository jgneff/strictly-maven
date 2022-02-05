#!/bin/sh
# debian.sh - starts the Apache Maven build tool with the local Debian repo
# Copyright 2022 John Neffenger
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

# Starts Maven
"$SNAP/bin/maven.sh" --settings /etc/maven/settings-debian.xml "$@"
