#!/bin/sh
redis-server &
sudo service canopy_server_comm start
sudo service canopy_server_paas start
cd ~/meteor/canopy_server_dashboard
(env REDIS_CONFIGURE_KEYSPACE_NOTIFICATIONS=1 meteor) &
#sudo chmod 777 /var/run/docker.sock
