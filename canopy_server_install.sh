#!/bin/sh
set -e

sudo apt-get update
wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.7.3.linux-amd64.tar.gz
sudo apt-get install curl -y
sudo apt-get install redis-server -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o \
    Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confnew" install docker.io
# sudo apt-get install docker.io -y
sudo apt-get install python-pip -y
curl https://install.meteor.com/ | sh
cd ~
# echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
# echo 'export GOPATH=$HOME/go' >> ~/.bashrc
# echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
export GOPATH=$(pwd)/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$PATH:/usr/local/go/bin
mkdir -p go/src/github.com/canopy-ros
mkdir -p go/bin
mkdir -p go/pkg
cd go/src/github.com/canopy-ros
/usr/local/go/bin/go version
/usr/local/go/bin/go get github.com/gorilla/websocket
/usr/local/go/bin/go get github.com/garyburd/redigo/redis
/usr/local/go/bin/go get github.com/docker/engine-api
/usr/local/go/bin/go get github.com/docker/go-connections
/usr/local/go/bin/go get github.com/docker/go-units
/usr/local/go/bin/go get github.com/docker/distribution
/usr/local/go/bin/go get github.com/Sirupsen/logrus
/usr/local/go/bin/go get golang.org/x/net/context
/usr/local/go/bin/go get golang.org/x/net/proxy
/usr/local/go/bin/go get github.com/opencontainers/runc || true
/usr/local/go/bin/go get gopkg.in/mgo.v2
git clone https://github.com/canopy-ros/canopy_server_comm
cd canopy_server_comm
/usr/local/go/bin/go install
cd ..
git clone https://github.com/canopy-ros/canopy_server_paas
cd canopy_server_paas
/usr/local/go/bin/go install
cd docker
sudo docker build --tag="canopy" .
mkdir -p ~/meteor
cd ~/meteor
git clone https://github.com/canopy-ros/canopy_server_dashboard
