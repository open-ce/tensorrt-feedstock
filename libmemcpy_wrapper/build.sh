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

${GCC} -shared -fPIC -fno-builtin -c memcpy.c

${GCC} -shared -fPIC -Wl,--version-script memcpy.map -o libmemcpy-2.14.so memcpy.o -lc

cp libmemcpy-2.14.so ${PREFIX}/lib/
