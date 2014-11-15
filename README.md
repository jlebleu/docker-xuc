Dockerfile for Xuc

## Install Docker

To install docker on Linux :

    curl -sL https://get.docker.io/ | sh
 
 or
 
     wget -qO- https://get.docker.io/ | sh

## Build

To build the image, simply invoke

    docker build -t xuc github.com/sboily/docker-xuc

Or directly in the sources

    docker build -t xuc .
  
## Usage

To run the container, do the following:

    docker run -d -P xuc

On interactive mode :

    docker run -i -t xuc /bin/bash

## Infos

- Using docker version 1.3.1 (from get.docker.io) on ubuntu 14.04.
- If you want to using a simple webi to administrate docker use : https://github.com/crosbymichael/dockerui

To get the IP of your container use :

    docker ps -a
    docker inspect <container_id> | grep IPAddress | awk -F\" '{print $4}'
