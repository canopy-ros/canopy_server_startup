# TODO FROM

# TODO ENV

RUN apt-get update

RUN apt-get install -y \
    curl \
    redis-server \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    python-pip \
    chrony

# Install docker-ce
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -o \
    Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confnew" install docker-ce

# Install go 1.9 and set PATH
RUN wget https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz
RUN echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc \
    && echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> $HOME/.bashrc
RUN source ~/.bashrc

# Initialize go and Canopy directories
WORKDIR ~
RUN mkdir -p go/src/github.com/canopy-ros
RUN mkdir -p go/bin
RUN mkdir -p go/pkg
WORKDIR go/src/github.com/canopy-ros
RUN git clone https://github.com/canopy-ros/canopy_server_comm
RUN git clone https://github.com/canopy-ros/canopy_server_paas

# Install Canopy go dependencies with govendor
RUN go get -u github.com/kardianos/govendor
WORKDIR go/src/github.com/canopy-ros/canopy_server_comm
RUN govendor sync
RUN govendor install
WORKDIR go/src/github.com/canopy-ros/canopy_server_paas
RUN govendor sync
RUN govendor install
WORKDIR go/src/github.com/canopy-ros/


