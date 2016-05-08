noop                   =
space                  = $(noop) $(noop)
comma                  =$(noop),$(noop)

# Googleapis types
grpcimports           = Mgoogle/api/annotations.proto=github.com/googleapis/googleapis/google/api/annotations
grpcimports           += Mgoogle/api/http.proto=github.com/googleapis/googleapis/google/api/http
grpcimports           += Mgoogle/api/label.proto=github.com/googleapis/googleapis/google/api/label
grpcimports           += Mgoogle/api/monitored_resource.proto=github.com/googleapis/googleapis/google/api/monitored_resource

grpcimports           += Mgoogle/bigtable/admin/table/v1/bigtable_table_data.proto=github.com/googleapis/googleapis/google/bigtable/admin/table/v1/bigtable_table_data
grpcimports           += Mgoogle/bigtable/admin/table/v1/bigtable_table_service.proto=github.com/googleapis/googleapis/google/bigtable/admin/table/v1/bigtable_table_service
grpcimports           += Mgoogle/bigtable/admin/table/v1/bigtable_table_service_messages.proto=github.com/googleapis/googleapis/google/bigtable/admin/table/v1/bigtable_table_service_messages

grpcimports           += Mgoogle/bigtable/v1/bigtable_data.proto=github.com/googleapis/googleapis/google/bigtable/v1/bigtable_data
grpcimports           += Mgoogle/bigtable/v1/bigtable_service.proto=github.com/googleapis/googleapis/google/bigtable/v1/bigtable_service
grpcimports           += Mgoogle/bigtable/v1/bigtable_service_messages.proto=github.com/googleapis/googleapis/google/bigtable/v1/bigtable_service_messages

grpcimports           += Mgoogle/cloud/speech/v1/cloud_speech.proto=github.com/googleapis/googleapis/google/cloud/speech/v1/cloud_speech

grpcimports           += Mgoogle/container/v1/cluster_service.proto=github.com/googleapis/googleapis/google/container/v1/cluster_service

grpcimports           += Mgoogle/datastore/v1beta3/datastore.proto=github.com/googleapis/googleapis/google/datastore/v1beta3/datastore
grpcimports           += Mgoogle/datastore/v1beta3/entity.proto=github.com/googleapis/googleapis/google/datastore/v1beta3/entity
grpcimports           += Mgoogle/datastore/v1beta3/query.proto=github.com/googleapis/googleapis/google/datastore/v1beta3/query

grpcimports           += Mgoogle/example/library/v1/library.proto=github.com/googleapis/googleapis/google/example/library/v1/library

grpcimports           += Mgoogle/iam/v1/iam_policy.proto=github.com/googleapis/googleapis/google/iam/v1/iam_policy
grpcimports           += Mgoogle/iam/v1/policy.proto=github.com/googleapis/googleapis/google/iam/v1/policy

grpcimports           += Mgoogle/logging/type/http_request.proto=github.com/googleapis/googleapis/google/logging/type/http_request
grpcimports           += Mgoogle/logging/type/log_severity.proto=github.com/googleapis/googleapis/google/logging/type/log_severity

grpcimports           += Mgoogle/logging/v2/log_entry.proto=github.com/googleapis/googleapis/google/logging/v2/log_entry
grpcimports           += Mgoogle/logging/v2/logging.proto=github.com/googleapis/googleapis/google/logging/v2/logging
grpcimports           += Mgoogle/logging/v2/logging_config.proto=github.com/googleapis/googleapis/google/logging/v2/logging_config
grpcimports           += Mgoogle/logging/v2/logging_metrics.proto=github.com/googleapis/googleapis/google/logging/v2/logging_metrics

grpcimports           += Mgoogle/longrunning/operations.proto=github.com/googleapis/googleapis/google/longrunning/operations

grpcimports           += Mgoogle/pubsub/v1/pubsub.proto=github.com/googleapis/googleapis/google/pubsub/v1/pubsub

grpcimports           += Mgoogle/pubsub/v1beta2/pubsub.proto=github.com/googleapis/googleapis/google/pubsub/v1beta2/pubsub

grpcimports           += Mgoogle/rpc/code.proto=github.com/googleapis/googleapis/google/rpc/code
grpcimports           += Mgoogle/rpc/error_details.proto=github.com/googleapis/googleapis/google/rpc/error_details
grpcimports           += Mgoogle/rpc/status.proto=github.com/googleapis/googleapis/google/rpc/status

grpcimports           += Mgoogle/type/color.proto=github.com/googleapis/googleapis/google/type/color
grpcimports           += Mgoogle/type/date.proto=github.com/googleapis/googleapis/google/type/date
grpcimports           += Mgoogle/type/dayofweek.proto=github.com/googleapis/googleapis/google/type/dayofweek
grpcimports           += Mgoogle/type/latlng.proto=github.com/googleapis/googleapis/google/type/latlng
grpcimports           += Mgoogle/type/money.proto=github.com/googleapis/googleapis/google/type/money
grpcimports           += Mgoogle/type/timeofday.proto=github.com/googleapis/googleapis/google/type/timeofday
# # Protobuf types
grpcimports           += Mgoogle/protobuf/descriptor.proto=github.com/golang/protobuf/protoc-gen-go/descriptor
grpcimports           += Mgoogle/protobuf/any.proto=github.com/golang/protobuf/ptypes/any
grpcimports           += Mgoogle/protobuf/duration.proto=github.com/golang/protobuf/ptypes/duration
grpcimports           += Mgoogle/protobuf/empty.proto=github.com/golang/protobuf/ptypes/empty
grpcimports           += Mgoogle/protobuf/struct.proto=github.com/golang/protobuf/ptypes/struct
grpcimports           += Mgoogle/protobuf/timestamp.proto=github.com/golang/protobuf/ptypes/timestamp
grpcimports           += Mgoogle/protobuf/wrappers.proto=github.com/golang/protobuf/ptypes/wrappers

GRPCREPLACEGOPATTERNS = $(subst $(space),$(comma),$(grpcimports))

PROTOINCLUDE ?= /usr/local/include
GOOGLEAPISPATH ?= $(GOPATH)/src/github.com/googleapis/googleapis
OUTPUT ?= ./out
PROTOC ?= protoc --proto_path=.:$(PROTOINCLUDE):$(GOOGLEAPISPATH) --go_out=$(GRPCREPLACEGOPATTERNS),plugins=grpc,import_path=$(subst $(OUTPUT)/,,$*):$(OUTPUT) $<
