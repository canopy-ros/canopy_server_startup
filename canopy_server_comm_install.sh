#!/bin/sh
#set -e

sudo apt-get update
sudo apt-get install curl -y
sudo apt-get install redis-server -y
sudo apt-get install python-pip -y
curl https://install.meteor.com/ | sh
cd ~
export GOPATH=$(pwd)/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$PATH:/usr/local/go/bin
mkdir -p go/src/github.com/canopy-ros
mkdir -p go/bin
mkdir -p go/pkg
cd go/src/github.com/canopy-ros
go version
go get github.com/gorilla/websocket
go get github.com/garyburd/redigo/redis
go get github.com/docker/engine-api
go get github.com/docker/go-connections
go get github.com/docker/go-units
go get github.com/docker/distribution
go get github.com/Sirupsen/logrus
go get golang.org/x/net/context
go get golang.org/x/net/proxy
go get github.com/opencontainers/runc || true
go get gopkg.in/mgo.v2
git clone https://github.com/canopy-ros/canopy_server_comm
cd canopy_server_comm
go install
mkdir -p ~/meteor
cd ~/meteor
git clone https://github.com/canopy-ros/canopy_server_dashboard
