#!/bin/sh
set -e

export CANOPY_DIR=$(pwd)
sudo apt-get update
GIMME_OUTPUT=$(gimme 1.7.3) && eval "$GIMME_OUTPUT"
wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.7.3.linux-amd64.tar.gz
sudo apt-get install curl -y
sudo apt-get install redis-server -y
sudo apt-get install apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o \
    Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confnew" install docker-ce
sudo apt-get install python-pip -y
curl https://install.meteor.com/ | sudo sh
cd $HOME
#echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
#echo 'export GOPATH=$HOME/go' >> ~/.bashrc
#echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
export GOPATH=$(pwd)/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$PATH:/usr/local/go/bin
mkdir -p go/src/github.com/canopy-ros
mkdir -p go/bin
mkdir -p go/pkg
cd go/src/github.com/canopy-ros
go version
go get -u github.com/kardianos/govendor
govendor init
govendor fetch github.com/gorilla/websocket
govendor fetch github.com/garyburd/redigo/redis
govendor fetch github.com/docker/engine-api/^
govendor fetch github.com/docker/go-connections
govendor fetch github.com/docker/go-units
govendor fetch github.com/docker/distribution
govendor fetch github.com/Sirupsen/logrus
govendor fetch golang.org/x/net/context
govendor fetch golang.org/x/net/proxy
govendor fetch github.com/opencontainers/runc || true
govendor fetch gopkg.in/mgo.v2
govendor fetch github.com/pkg/errors
git clone https://github.com/canopy-ros/canopy_server_comm
cd canopy_server_comm
govendor install +local
cd ..
git clone https://github.com/canopy-ros/canopy_server_paas
cd canopy_server_paas
govendor install +local
cd docker
sudo docker build --tag="canopy" .
mkdir -p $HOME/meteor
cd $HOME/meteor
git clone https://github.com/canopy-ros/canopy_server_dashboard
cd $CANOPY_DIR
sudo mkdir -p /etc/default/ 
sudo "PATH=$PATH" sh -c 'echo "PATH=$PATH" > /etc/default/canopy'
if [ -d /lib/systemd/ ]; then
    sudo cp canopy_server_comm.service /lib/systemd/system
    sudo cp canopy_server_paas.service /lib/systemd/system
fi
if [ -d /etc/init/ ]; then
    sudo cp canopy_server_comm.conf /etc/init
    sudo cp canopy_server_paas.conf /etc/init
fi
