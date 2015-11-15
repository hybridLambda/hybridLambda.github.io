#!/bin/bash
# USAGE: ubuntuBinaryPackaging.sh 4.4
GCCVERSION=$1
GPP=g++-${GCCVERSION}
VERSION=v0.6.1-beta

if [ -f hybrid-Lambda-${GPP}.zip ]; then
  rm hybrid-Lambda-${GPP}.zip
fi

if [ -f hybrid-Lambda-${GPP}.tar.gz ]; then
  rm hybrid-Lambda-${GPP}.tar.gz
fi

if [ -d packagingDir ]; then
  rm -rf packagingDir
fi

if [ ! -f hybrid-lambda-${VERSION}.tar.gz ]; then
    wget --no-check-certificate http://hybridlambda.github.io/release/hybrid-lambda-${VERSION}.tar.gz
fi
mkdir packagingDir
tar -xzf hybrid-lambda-${VERSION}.tar.gz -C packagingDir
cd packagingDir/hybrid-lambda-${VERSION}/src
#./bootstrap
#./configure CXX=${GPP}
echo "
COMPILER = ${GPP}
VERSION = \$(shell cat ../version)
FLAGS = -O3 -g -std=c++0x -DNDEBUG -DVERSION=\\\"\${VERSION}\\\" -I../src/ -static

.PHONY: all
all: clean_all checkfile hybrid-Lambda

.PHONY: checkfile
checkfile:
	./checkfiles.sh

hybrid-Lambda: figure.o freq.o sim_gt.o
	\${COMPILER} \${FLAGS} -o hybrid-Lambda debug/node_debug.cpp debug/net_debug.cpp main.cpp  fastfunc.cpp mersenne_twister.cpp random_generator.cpp net.cpp  node.cpp hybridLambda.cpp figure.o freq.o sim_gt.o regular_math.o

sim_gt.o: regular_math.o
	\${COMPILER} \${FLAGS} -c sim_gt.cpp

regular_math.o:
	\${COMPILER} \${FLAGS} -c regular_math.cpp

freq.o:
	\${COMPILER} \${FLAGS} -c freq/freq.cpp

figure.o:
	\${COMPILER} \${FLAGS} -c plot/figure.cpp

.PHONY: clean
clean:
	rm -f *.o

.PHONY: clean_all
clean_all:
	rm -f *.o hybrid-Lambda
" > Makefile

make
#mv hybrid-Lambda_static hybrid-Lambda
zip hybrid-Lambda-${GPP}.zip hybrid-Lambda
mv hybrid-Lambda-${GPP}.zip ../../..
