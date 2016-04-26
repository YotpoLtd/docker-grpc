noop                   =
space                  = $(noop) $(noop)
comma                  =$(noop),$(noop)
grpcimports           =  Mgoogle/api/annotations.proto=github.com/googleapis/googleapis/google/api
grpcimports           += Mgoogle/api/http.proto=github.com/googleapis/googleapis/google/api
grpcimports           += Mgoogle/api/label.proto=github.com/googleapis/googleapis/google/api
grpcimports           += Mgoogle/api/monitored_resource.proto=github.com/googleapis/googleapis/google/api

grpcimports           += Mgoogle/longrunning/operations.proto=github.com/googleapis/googleapis/google/longrunning

grpcimports           += Mgoogle/bigtable/v1/bigtable_data.proto=github.com/googleapis/googleapis/google/bigtable/v1
grpcimports           += Mgoogle/bigtable/v1/bigtable_service.proto=github.com/googleapis/googleapis/google/bigtable/v1
grpcimports           += Mgoogle/bigtable/v1/bigtable_service_message.proto=github.com/googleapis/googleapis/google/bigtable/v1

grpcimports           += Mgoogle/bigtable/admin/table/v1/bigtable_table_data.proto=github.com/googleapis/googleapis/google/bigtable/admin/table/v1
grpcimports           += Mgoogle/bigtable/admin/table/v1/bigtable_table_service.proto=github.com/googleapis/googleapis/google/bigtable/admin/table/v1
grpcimports           += Mgoogle/bigtable/admin/table/v1/bigtable_table_service_message.proto=github.com/googleapis/googleapis/google/bigtable/admin/table/v1

grpcimports           += Mgoogle/rpc/status.proto=github.com/googleapis/googleapis/google/rpc

grpcimports           += Mgoogle/logging/type/http_request.proto=github.com/googleapis/googleapis/google/logging/type
grpcimports           += Mgoogle/logging/type/log_severity.proto=github.com/googleapis/googleapis/google/logging/type

grpcimports           += Mgoogle/iam/v1/policy.proto=github.com/googleapis/googleapis/google/iam/v1

grpcimports           += Mgoogle/datastore/v1beta3/entity.proto=github.com/googleapis/googleapis/google/datastore/v1beta3
grpcimports           += Mgoogle/datastore/v1beta3/query.proto=github.com/googleapis/googleapis/google/datastore/v1beta3

grpcimports           += Mgoogle/protobuf/descriptor.proto=github.com/google/protobuf/src/google/protobuf
grpcimports           += Mgoogle/protobuf/any.proto=github.com/google/protobuf/src/google/protobuf/github.com/golang/protobuf/ptypes/any
grpcimports           += Mgoogle/protobuf/duration.proto=github.com/google/protobuf/src/google/protobuf/github.com/golang/protobuf/ptypes/duration
grpcimports           += Mgoogle/protobuf/empty.proto=github.com/google/protobuf/src/google/protobuf/github.com/golang/protobuf/ptypes/empty
grpcimports           += Mgoogle/protobuf/struct.proto=github.com/google/protobuf/src/google/protobuf/github.com/golang/protobuf/ptypes/struct
grpcimports           += Mgoogle/protobuf/timestamp.proto=github.com/google/protobuf/src/google/protobuf/github.com/golang/protobuf/ptypes/timestamp
grpcimports           += Mgoogle/protobuf/wrappers.proto=github.com/google/protobuf/src/google/protobuf/github.com/golang/protobuf/ptypes/wrappers
GRPCREPLACEGOPATTERNS = $(subst $(space),$(comma),$(grpcimports))
#Shamelessly copied from github.com/googleapis/googleapis/Makefile and modified to build what I need :)

# Choose the proto include directory.
PROTOINCLUDE ?= /usr/local/include
FLAGS = --proto_path=.:$(PROTOINCLUDE)
FLAGS += --go_out=$(GRPCREPLACEGOPATTERNS),plugins=grpc:.

DEPS:= $(shell find . -type f -name '*.proto' | grep -v _test | grep -v unitt | grep -v testdata | grep -v devtools |sed "s/proto$$/pb.go/")

all: $(DEPS)

%.pb.go: %.proto
	@protoc $(FLAGS) $<

