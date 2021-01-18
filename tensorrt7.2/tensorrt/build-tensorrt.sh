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

mkdir -p ${PREFIX}/{include,lib,lib64,doc/tensorrt}

export CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/ -std=[^ ]*//')"

# Copy tensorrt files into $PREFIX
cp -a ${SRC_DIR}/tensorrt/include/* ${PREFIX}/include
cp -a ${SRC_DIR}/tensorrt/bin/* ${PREFIX}/bin
cp -a ${SRC_DIR}/tensorrt/lib/libmyelin* ${PREFIX}/lib
cp -a ${SRC_DIR}/tensorrt/lib/libnv* ${PREFIX}/lib
cp -a ${SRC_DIR}/tensorrt/doc/pdf/* ${PREFIX}/doc/tensorrt

# Build onnx-tensorrt
cd ${SRC_DIR}/TensorRT
export TRT_SOURCE=`pwd`

mkdir build
cd build

# only interested in onnx2trt here
cmake .. -DBUILD_PARSERS="OFF" -DBUILD_PLUGINS="OFF" -DBUILD_SAMPLES="OFF" -DCMAKE_C_COMPILER=${CC} \
         -DCMAKE_CUDA_COMPILER=${CUDA_HOME}/bin/nvcc -DCMAKE_CUDA_HOST_COMPILER=${CXX} -DPROTOBUF_VERSION=${protobuf%.*} \
         -DCMAKE_INSTALL_PREFIX=${PREFIX}

cmake --build . --target install -- -j${CPU_COUNT} || exit 4

cd ..

if [ -f ${SRC_DIR}/tensorrt/python/tensorrt*p${CONDA_PY}*.whl ]; then
    export PYTHONUSERBASE=${PREFIX}
    ${PYTHON} -m pip install --no-deps --ignore-installed ${SRC_DIR}/tensorrt/python/tensorrt*p${CONDA_PY}*.whl
fi
