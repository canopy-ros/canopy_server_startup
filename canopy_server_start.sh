#!/bin/sh
redis-server &
canopy_server_comm --addr="$(hostname -I | cut -d' ' -f1):8080" &
canopy_server_paas --addr="$(hostname -I | cut -d' ' -f1)" --port=8080 &
cd ~/meteor/canopy_server_dashboard
(env REDIS_CONFIGURE_KEYSPACE_NOTIFICATIONS=1 meteor) &
#sudo chmod 777 /var/run/docker.sock
