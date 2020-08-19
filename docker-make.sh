#!/bin/bash
export NODE_RED_VERSION=$(grep -oE "\"node-red\": \"(\w*.\w*.\w*)\"" package.json | cut -d\" -f4)

echo "#########################################################################"
echo "node-red version: ${NODE_RED_VERSION}"
echo "#########################################################################"

docker build --no-cache \
    --build-arg NODE_RED_VERSION=${NODE_RED_VERSION} \
    --build-arg OS=ubuntu:bionic \
    --file Dockerfile \
    --tag node-red:1.0.0 .
