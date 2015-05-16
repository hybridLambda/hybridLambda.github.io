#!/bin/bash
# USAGE: ubuntuBinaryPackaging.sh 4.4
GCCVERSION=$1
GPP=g++-${GCCVERSION}
VERSION=v0.6-beta

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
cd packagingDir/hybrid-lambda-${VERSION}
./bootstrap
./configure CXX=${GPP}
make
zip hybrid-Lambda-${GPP}.zip hybrid-Lambda
mv hybrid-Lambda-${GPP}.zip ../..
