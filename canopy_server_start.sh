#!/bin/sh
set -e

OPTS=$(getopt -n "$0" -o h --long help,dashboard:: -- "$@")
eval set -- "$OPTS"
DASHBOARD=0
while true; do
    case "$1" in
	--help|-h)
	    echo "usage: canopy_server_start [--dashboard[=METEOR_PATH]]"
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

redis-server &
sudo service canopy_server_comm start
sudo service canopy_server_paas start
if [ $DASHBOARD -eq 1 ]; then
    cd $METEOR_PATH/meteor/canopy_server_dashboard
    (env REDIS_CONFIGURE_KEYSPACE_NOTIFICATIONS=1 meteor) &
fi
#sudo chmod 777 /var/run/docker.sock
