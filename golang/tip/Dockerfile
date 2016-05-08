FROM golang:latest

RUN apt-get update && \
    apt-get -y install git unzip build-essential autoconf libtool

# install protobuf from source
ENV PROTO_VERSION ${PROTO_VERSION:-3.0.0-beta-2}

RUN wget "https://github.com/google/protobuf/archive/v${PROTO_VERSION}.tar.gz" -O protobuf.tar.gz -o /dev/null && \
    tar -xzf protobuf.tar.gz && \
    cd protobuf-${PROTO_VERSION} && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    make clean && \
    cd .. && \
    rm -r protobuf-${PROTO_VERSION} protobuf.tar.gz

# Get the source from GitHub
RUN go get -u google.golang.org/grpc
# Install protoc-gen-go
RUN go get -u github.com/golang/protobuf/protoc-gen-go
# Install Google APIS protos
RUN git clone https://github.com/googleapis/googleapis.git $GOPATH/src/github.com/googleapis/googleapis
# Install GRPC Gateway
RUN go get -u github.com/gengo/grpc-gateway/protoc-gen-grpc-gateway
# Install GRPC Gateway swagger
RUN go get -u github.com/gengo/grpc-gateway/protoc-gen-swagger

ENV PROJECT_PATH ${PROJECT_PATH:-$GOPATH/src/github.com/YotpoLtd/docker-grpc}

RUN mkdir -p $PROJECT_PATH
WORKDIR $PROJECT_PATH
ADD GoogleApis.make $PROJECT_PATH
ADD Makefile.inc $PROJECT_PATH
# Generate google apis
RUN make -f GoogleApis.make
