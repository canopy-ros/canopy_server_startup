# canopy_server_startup
![Build Status](https://travis-ci.org/canopy-ros/canopy_server_startup.svg?branch=master) ![Docs Status](http://readthedocs.org/projects/canopy-docs/badge/?version=latest)

## Requirements
- Docker 1.13.0+ (https://docs.docker.com/install/)
- Docker Compose (https://docs.docker.com/compose/install/)

## Running
To build and run the Canopy server stack:
```
git clone https://github.com/canopy-ros/canopy_server_startup.git
cd canopy_server_startup
docker-compose build
docker-compose up
```

Additional options for Canopy server deployment are described below.

## Server Configuration Options
This section describes how to customize your Canopy server's deployment by specifying options in a configuration file. 

### Specify configuration
First create a `config.yml` file in your `/etc/canopy/` directory:
```
sudo mkdir -p /etc/canopy
cd /etc/canopy
sudo touch config.yml
```
 
Edit `config.yml` to add key-value pairs corresponding to options you want to customize your deployment with:

| Option           | Key   | Values          |
| ---------------- |-------| -------------   |
| Database Logging | `db`  | `redis`, `none` |

- **Database Logging**: log messages passed between Canopy clients and the Canopy Comm server to the specified database 

Example `config.yml` to enable database logging to Redis:
```
db: redis
```

### Redeploy
Rebuild and rerun the Canopy server stack:
```
cd <canopy_server_startup directory>
docker-compose build
docker-compose up
```

## Clock Synchronization
This section describes how to synchronize the clocks of your Canopy server and your Canopy clients using the `chrony` NTP clock synchronization package. 

### Server-side setup
A base chrony configuration file is provided in this repository. On your Canopy server, copy the configuration file to `/etc/chrony`:
```
sudo mkdir -p /etc/chrony
cd <canopy_server_startup directory>
sudo cp chrony.conf /etc/chrony
```

The provided configuration file synchronizes the Canopy servers to 3 global NTP servers. If you want to modify this configuration, you can edit `chrony.conf` accordingly (see https://chrony.tuxfamily.org/doc/3.3/chrony.conf.html for details). 

### Client-side setup
Follow instructions to setup chrony on your Canopy clients.

### Redeploy
Rebuild and rerun the Canopy server stack:
```
cd <canopy_server_startup directory>
docker-compose build
docker-compose up
```

To check whether chrony is working properly, look for messages similar to the following in your Docker logs:
```
fc21f432c421_docker_chrony_1 | 2018-05-06T18:07:03Z chronyd version 3.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SECHASH +SIGND +ASYNCDNS +IPV6 +DEBUG)
fc21f432c421_docker_chrony_1 | 2018-05-06T18:07:03Z Frequency 24.044 +/- 1000000.000 ppm read from /var/lib/chrony/chrony.drift
fc21f432c421_docker_chrony_1 | 2018-05-06T18:07:08Z Selected source 162.210.110.4
```
