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
mkdir -p ${PREFIX}/{include,lib,lib64,doc/tensorrt}

export CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/ -std=[^ ]*//')"

#add ugly patch for GLIBC_2.14 memcpy
cp ${RECIPE_DIR}/libmemcpy-2.14.so ${PREFIX}/lib/

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
