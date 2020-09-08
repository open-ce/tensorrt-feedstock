#!/bin/bash
# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2019,2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
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
patch -p1 < ${RECIPE_DIR}/uff_tf2.x_compatbility_fixes.patch
cd ../..
wheel pack uff-${PKG_VERSION}

${PYTHON} -m pip install --user --no-deps --ignore-installed ${SRC_DIR}/tensorrt/uff/uff-${PKG_VERSION}*.whl
