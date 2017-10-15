#!/bin/sh
redis-server &
service start canopy_server_comm.service
service start canopy_server_paas.service
cd ~/meteor/canopy_server_dashboard
(env REDIS_CONFIGURE_KEYSPACE_NOTIFICATIONS=1 meteor) &
#sudo chmod 777 /var/run/docker.sock
