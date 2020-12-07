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

${GCC} -shared -fPIC -fno-builtin -c clock_gettime.c

${GCC} -shared -fPIC -Wl,--version-script clock_gettime.map -o libclock_gettime-2.17.so clock_gettime.o -lc

cp libclock_gettime-2.17.so ${PREFIX}/lib/
