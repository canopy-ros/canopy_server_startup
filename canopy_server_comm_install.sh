#!/bin/sh
#set -e

sudo apt-get update
wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
mkdir -p ws/src/github.com/canopy-ros
mkdir -p ws/bin
mkdir -p ws/pkg
sudo tar -xzf go1.7.3.linux-amd64.tar.gz
sudo apt-get install curl -y
sudo apt-get install redis-server -y
sudo apt-get install python-pip -y
export GOPATH=$(pwd)/ws
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$(pwd)/go/bin
cd ws/src/github.com/canopy-ros
go get github.com/Sirupsen/logrus
go get golang.org/x/net/context
go get github.com/gorilla/websocket
go get github.com/garyburd/redigo/redis
go get golang.org/x/net/proxy
git clone https://github.com/canopy-ros/canopy_server_comm
cd canopy_server_comm
go install
