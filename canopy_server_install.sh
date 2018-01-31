#!/bin/sh
export CANOPY_DIR=$(pwd)

# trap errors
function err_fn() {
    echo 'ERROR - aborting script.'
    cd $CANOPY_DIR
    trap - ERR
}
trap "err_fn; return" ERR

OPTS=$(getopt -n "$0" -o h --long help,dashboard:: -- "$@")
eval set -- "$OPTS"
DASHBOARD=0
while true; do
    case "$1" in
	--help|-h)
	    echo "usage: canopy_server_install [--dashboard[=METEOR_PATH]]"
	    exit;;
	--dashboard)
	    DASHBOARD=1
	    case "$2" in
		"") METEOR_PATH=$HOME; shift 2;;
		*) METEOR_PATH=$2; shift 2;;
	    esac;;
	--) shift; break;;
	*) break;;
    esac
done

sudo apt-get update
wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz
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
sudo apt-get install chrony -y

# set path
grep -q 'export GOPATH=$HOME/go' $HOME/.bashrc || echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
grep -q 'export PATH=$PATH:/usr/local/go/bin' $HOME/.bashrc || echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
grep -q 'export PATH=$PATH:$GOPATH/bin' $HOME/.bashrc || echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.bashrc
. $HOME/.bashrc

# set up services with systemd/upstart
sudo mkdir -p /etc/default/ 
sudo "PATH=$PATH" sh -c 'echo "PATH=$PATH" > /etc/default/canopy'
if [ -d /lib/systemd/ ]; then
    sudo cp canopy_server_comm.service /lib/systemd/system
    sudo cp canopy_server_paas.service /lib/systemd/system
    sudo cp chrony_canopy_server.service /lib/systemd/system
fi
if [ -d /etc/init/ ]; then
    sudo cp canopy_server_comm.conf /etc/init
    sudo cp canopy_server_paas.conf /etc/init
fi

# copy chrony config file
sudo cp chrony_canopy_server.conf /etc/chrony/

# copy canopy config file
if [ 0 -lt $(ls config.* 2>/dev/null | wc -w) ]; then
    sudo mkdir -p /etc/canopy/
    sudo cp config.yaml /etc/canopy/
fi

# initialize go directory
cd $HOME
mkdir -p go/src/github.com/canopy-ros
mkdir -p go/bin
mkdir -p go/pkg
cd go/src/github.com/canopy-ros
if [ ! -d canopy_server_comm ]; then
    git clone https://github.com/canopy-ros/canopy_server_comm
fi
if [ ! -d canopy_server_paas ]; then
    git clone https://github.com/canopy-ros/canopy_server_paas
fi

# install go dependencies with govendor
echo "installing go dependencies..."
go get -u github.com/kardianos/govendor
cd canopy_server_comm
govendor sync
govendor install
cd ../canopy_server_paas
govendor sync
govendor install

# set up docker in paas server
cd docker
sudo docker build --tag="canopy" .

# set up dashboard
if [ $DASHBOARD -eq 1 ]; then
    mkdir -p $METEOR_PATH/meteor
    cd $METEOR_PATH/meteor
    if [ ! -d canopy_server_dashboard ]; then
        git clone https://github.com/canopy-ros/canopy_server_dashboard
    fi
fi

cd $CANOPY_DIR
trap - ERR
echo "SUCCESS - script successfully installed."
