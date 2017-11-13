#!/bin/sh

curl https://install.meteor.com/ | sudo sh
sudo chown -R $USER $HOME/.meteor
