#!/bin/bash
# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************

export PYTHONUSERBASE=${PREFIX}

${PYTHON} -m pip install --user --no-deps --ignore-installed ${SRC_DIR}/tensorrt/onnx_graphsurgeon/onnx_graphsurgeon-${PKG_VERSION}*.whl
