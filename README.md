# canopy_server_startup
![Build Status](https://travis-ci.org/canopy-ros/canopy_server_startup.svg?branch=master) ![Docs Status](http://readthedocs.org/projects/canopy-docs/badge/?version=latest)

Source code for Canopy server deployment 

## Requirements
- Docker (https://docs.docker.com/install/)

## Running
To build and run the Canopy server stack:
```
cd docker
docker-compose build
docker-compose up
```

Additional options for Canopy server installation and execution can be found in the next sections.

## Server Configuration Options
Configuration options for the Communication and Paas servers can be specified in a `config.*` file in any of the following formats: JSON, TOML, YAML, HCL, or Java properties. The config file should placed in the `docker/` directory.

The following keys and values are supported in the config file:
- `db`: `redis`, `none`
