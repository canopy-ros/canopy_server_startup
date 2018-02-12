# canopy_server_startup
![Build Status](https://travis-ci.org/canopy-ros/canopy_server_startup.svg?branch=master) ![Docs Status](http://readthedocs.org/projects/canopy-docs/badge/?version=latest)

Development repo containing start-up scripts for the Canopy server stack.

## Installation and Execution
To install the Canopy server stack, run the following:
```
source ./canopy_server_install.sh
```

To execute the Canopy servers, run the following:
```
./canopy_server_start.sh
```

To view log outputs from the servers:
- If your system uses **systemd** (Ubuntu 15.04+):
```
# live communication server logs
journalctl -f -u canopy_server_comm

# open new terminal for live paas server logs
journalctl -f -u canopy_server_paas
```

- If your system uses **Upstart** (prior to Ubuntu 15.04):
```
# live communication server logs
tail -f /var/log/upstart/canopy_server_comm.log

# open new terminal for live paas server logs
tail -f /var/log/upstart/canopy_server_paas.log
```

Additional options for Canopy server installation and execution can be found in the next sections.

## Dashboard
To use the dashboard, you must have Meteor installed and set the ownership of the `.meteor` folder:
```
curl https://install.meteor.com/ | sudo sh
sudo chown -R $USER $HOME/.meteor
```

To run the dashboard, you must specify the `--dashboard` option when executing the install and start scripts. You can specify the path where the dashboard Meteor directory will be located, otherwise your home directory will be used by default:
```
. ./canopy_server_install.sh --dashboard=/your/dashboard/path
./canopy_server_start.sh --dashboard=/your/dashboard/path
```
## Server Configuration Options
Configuration options for the Communication and Paas servers can be specified in a `config.*` file in any of the following formats: JSON, TOML, YAML, HCL, or Java properties. The config file should placed in the top level of this directory.

The following keys and values are supported in the config file:
- `db`: `redis`, `none`

## Clock Synchronization
This section includes the _server-side_ instructions for synchronizing the clocks of the Canopy server and the Canopy clients using `chrony`. 

#### Setting up chrony
Edit the chrony configuration file in `/etc/chrony/chrony_canopy_server.conf` by uncommenting the `allow` line and replacing the placeholder IP with your Canopy clients' IP addresses:
```
# /etc/chrony/chrony_canopy_server.conf
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst

allow 128.31.37.168
allow 128.31.37.167
...
```

Disable and stop the default chrony service (it's fine if it gives a warning after the disable step):
```
sudo systemctl stop chrony
sudo systemctl disable chrony
```

Enable and start the Canopy chrony service:
```
sudo systemctl enable chrony_canopy_server
sudo systemctl start chrony_canopy_server
```

#### Checking chrony setup
To check whether the service is running correctly, run `systemctl status chrony_canopy_server` which should show an active running status:
```
chrony_canopy_server.service - chrony service for canopy server
Loaded: loaded (/lib/systemd/system/chrony_canopy_server.service; static; vendor preset: enabled)
Active: active (running)
...
```

To check whether the chrony daemon `chronyd` is working correctly, run `chronyc activity` which should return the following:
```
200 OK
3 sources online
0 sources offline
0 sources doing burst (return to online)
0 sources doing burst (return to offline)
0 sources with unknown address
```
If you see the message `506 Cannot talk to daemon`, then `chronyd` is not running properly.
