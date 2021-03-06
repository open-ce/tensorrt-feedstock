#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2019, 2021. All Rights Reserved.
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
# *****************************************************************

export PYTHONUSERBASE=${PREFIX}

# Here, we are applying a patch that fixes uff to make it 
# compatible with TF 2.x. 
# NOTE: Once NVIDIA fixes these compatibility issues in the upstream 
# uff, we would need to remove below few lines that applies patch
# on an unpacked wheel file and packs again.

cd ${SRC_DIR}/tensorrt/uff
wheel unpack uff-${PKG_VERSION}*.whl
cd uff-${PKG_VERSION}/uff
patch -p1 < ${RECIPE_DIR}/0301-uff_tf2.x_compatbility_fixes.patch
cd ../..
wheel pack uff-${PKG_VERSION}

${PYTHON} -m pip install --user --no-deps --ignore-installed ${SRC_DIR}/tensorrt/uff/uff-${PKG_VERSION}*.whl
