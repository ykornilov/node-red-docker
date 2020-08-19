# Build your own Node-RED Docker image base on Ubuntu

## Motivation

This repository created on the basis of https://github.com/node-red/node-red-docker/
But simplified and redesigned to run Node-RED (http://nodered.org) docker-container on the operating system Ubuntu


The docker-custom directory contains files you need to build your own images.

The follow steps describe in short which steps to take to build your own images.

## 1. git clone

Clone the Node-RED Docker project from github
```shell script
git clone https://github.com/ykornilov/node-red-docker.git
```

Change dir
```shell script
cd node-red-docker
```

## 2. **package.json**

   - Change the node-red version in package.json (from the docker-custom directory) to the version you require
   - Add optionally packages you require

## 3. **docker-make.sh**

The `docker-make.sh` is a helper script to build a custom Node-RED docker image.

Change the build arguments as needed:

   - `--build-arg NODE_RED_VERSION=${NODE_RED_VERSION}` : don't change this, ${NODE_RED_VERSION} gets populated from package.json
   - `--build-arg OS=ubuntu:bionic` : the linux distro to use
   - `--file Dockerfile` : Dockerfile to use to build your image.
   - `--tag node-red:1.0.0` : set the image name and tag

## 4. **Directory /settings**

The directory `/settings` contains user files for node-red:

   - `flows.json` : flow-application or empty file
   - `settings.js` : settings for start node-red
   - `package.json` : you can set node-dependencies for node-red

## 5. **Run docker-make.sh**

Run `docker-make.sh`

```shell script
$ sudo ./docker-make.sh
```

This starts building your custom image and might take a while depending on the system you are running on.

When building is done you can run the custom image by the following command:

```shell script
$ sudo docker run --rm -it -p 1880:1880 node-red:1.0.0
or
$ sudo docker run --rm -it -p 1880:1880 -e HOSTNAME="0.0.0.0" node-red:1.0.0
```

With the following command you can verify your docker image:

```shell script
$ sudo docker image inspect node-red:1.0.0
```

## 6. **Advanced Configuration**

`Dockerfile` can be modified as required