FROM golang:1.9

SHELL ["bash", "-c"]

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    python-pip \
    chrony

# Initialize Canopy directories
RUN mkdir -p /go/src/github.com/canopy-ros
WORKDIR /go/src/github.com/canopy-ros
RUN git clone https://github.com/canopy-ros/canopy_server_comm
RUN git clone https://github.com/canopy-ros/canopy_server_paas

# Install Canopy go dependencies with govendor
RUN go get -u github.com/kardianos/govendor
WORKDIR /go/src/github.com/canopy-ros/canopy_server_comm
RUN govendor sync
RUN govendor install
WORKDIR /go/src/github.com/canopy-ros/canopy_server_paas
RUN govendor sync
RUN govendor install
WORKDIR /go/src/github.com/canopy-ros/
