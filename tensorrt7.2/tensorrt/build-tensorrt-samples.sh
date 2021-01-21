#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2020, 2021. All Rights Reserved.
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

mkdir -p ${PREFIX}/samples/tensorrt/{samples,data}

# Patch to fix tensorrt incompatibility issues with TF 2.x
# Note: Remove this patch application once NVIDIA fixes this upstream
CUR_DIR=$(pwd)
cd ${SRC_DIR}/tensorrt/samples
patch -p1 < ${RECIPE_DIR}/0306-samples_tf2.x_compatibility_fixes.patch
cd $CUR_DIR

# copy opensource version of files from the TensorRT repo
cp -a ${SRC_DIR}/TensorRT/samples/opensource/* ${PREFIX}/samples/tensorrt/samples

# copy and create the common subdir in the samples destination dir
cp -a ${SRC_DIR}/TensorRT/samples/common ${PREFIX}/samples/tensorrt/samples

# copy and create the python subdir in the samples destination dir
if [ -f ${SRC_DIR}/tensorrt/python/tensorrt*p${CONDA_PY}*.whl ]; then
    cp -a ${SRC_DIR}/tensorrt/samples/python ${PREFIX}/samples/tensorrt/samples
fi

# grab the Makefiles from the tarball so we can use the NVIDIA readmes
cd ${SRC_DIR}/tensorrt/
find . -name "Makefile*" -exec cp --parents {} ${PREFIX}/samples/tensorrt/ \;

# note, these are patched when the source is downloaded, there
# are a few adjustments we make for open-ce
cp -a ${SRC_DIR}/tensorrt/data/* ${PREFIX}/samples/tensorrt/data

# Build onnx-tensorrt
cd ${SRC_DIR}/TensorRT
export TRT_SOURCE=`pwd`

if [[ ${target_platform} =~ .*ppc.* ]]; then
  SYSROOT_DIR="${BUILD_PREFIX}"/powerpc64le-conda_cos7-linux-gnu/sysroot/usr/
elif [[ ${target_platform} =~ .*x86_64.* || ${target_platform} =~ .*linux-64.* ]]; then
  SYSROOT_DIR="${BUILD_PREFIX}"/x86_64-conda_cos6-linux-gnu/sysroot/usr/
fi

mkdir -p build
cd build

cmake .. -DBUILD_SAMPLES="ON" -DBUILD_PARSERS="OFF" -DBUILD_PLUGINS="OFF" -DCMAKE_C_COMPILER=${CC} \
         -DCMAKE_CUDA_COMPILER=${CUDA_HOME}/bin/nvcc -DCMAKE_CUDA_HOST_COMPILER=${CXX} -DPROTOBUF_VERSION=${protobuf%.*} \
         -DCMAKE_LIBRARY_PATH="${SYSROOT_DIR}/lib" -DTENSORRT_ROOT=${PREFIX}/ -DCMAKE_INSTALL_PREFIX=${PREFIX} \
         -DCMAKE_CXX_FLAGS=" -I${PREFIX}/include -I${CUDA_HOME}/include" -DCUDA_INSTALL_DIR=${PREFIX}

make -j${CPU_COUNT} samples || exit 4

#copy binaries to the prefix area
cp -a ./sample_* ${PREFIX}/bin
