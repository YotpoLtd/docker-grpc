FROM grpc/go

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
