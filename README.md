# canopy_server_startup
![Build Status](https://travis-ci.org/canopy-ros/canopy_server_startup.svg?branch=master) ![Docs Status](http://readthedocs.org/projects/canopy-docs/badge/?version=latest)

Development repo containing start-up scripts for the Canopy server stack

### Dashboard
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
### Server Configuration Options
Configuration options for the Communication and Paas servers can be specified in a `config.*` file in any of the following formats: JSON, TOML, YAML, HCL, or Java properties. The config file should placed in the top level of this directory.

The following keys and values are supported in the config file:
- `db`: `redis`, `none`

### Clock Synchronization
This section includes the _server-side_ instructions for synchronizing the clocks of the Canopy server and the Canopy clients using `chrony`. 

Edit the chrony configuration file `chrony_canopy_server.conf` by uncommenting the `allow` line and replacing the placeholder IP with your Canopy clients' IP addresses:
```
# chrony_canopy_server.conf
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server 3.pool.ntp.org

allow 128.31.37.168
allow 128.31.37.167
...
```

Disable `chrony`:
```
sudo systemctl stop chronyd
```

Restart `chrony` with your configuration file:
```
sudo chronyd -f <absolute_path_to_config_file>/chrony_canopy_server.conf -r -s
```
