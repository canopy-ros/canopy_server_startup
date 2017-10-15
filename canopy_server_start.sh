#!/bin/sh
redis-server &
service canopy_server_comm.service start
service canopy_server_paas.service start
cd ~/meteor/canopy_server_dashboard
(env REDIS_CONFIGURE_KEYSPACE_NOTIFICATIONS=1 meteor) &
#sudo chmod 777 /var/run/docker.sock
