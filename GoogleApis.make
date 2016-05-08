#Shamelessly copied from github.com/googleapis/googleapis/Makefile and modified to build what I need :)
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))
include $(current_dir)/Makefile.inc

OUTPUT = $(GOOGLEAPISPATH)
PROTOS := $(shell find $(GOOGLEAPISPATH) -type f -name '*.proto' | grep -v _test | grep -v unitt | grep -v testdata | grep -v devtools)
DEPS := $(PROTOS:.proto=.pb.go)
DIR_DEPS := $(PROTOS:.proto=)

all: $(DIR_DEPS) $(DEPS)

deps: $(GOOGLEAPISPATH) grpc
	@go get -u github.com/golang/protobuf/proto
	@go get -u github.com/golang/protobuf/protoc-gen-go

$(DIR_DEPS):
	@mkdir $@

grpc:
	@bash ./install_grpc.sh

%.pb.go: %.proto
	@echo "M$(subst $(OUTPUT)/,,$<)=$(subst $(OUTPUT)/,,$*)"
	@$(PROTOC)
	@mv $*.pb.go $*/

$(GOOGLEAPISPATH):
	@echo "pulling googleapis to $(GOOGLEAPISPATH)"
	@git clone https://github.com/googleapis/googleapis.git $(GOOGLEAPISPATH)

clean:
	@rm -r $(DIR_DEPS)
