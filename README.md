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
