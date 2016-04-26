mkfile_path            := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir            := $(dir $(mkfile_path))
include $(current_dir)/Makefile.inc
#Shamelessly copied from github.com/googleapis/googleapis/Makefile and modified to build what I need :)

# Choose the proto include directory.
PROTOINCLUDE ?= /usr/local/include
FLAGS = --proto_path=.:$(PROTOINCLUDE)
FLAGS += --go_out=$(GRPCREPLACEGOPATTERNS),plugins=grpc:.

DEPS:= $(shell find . -type f -name '*.proto' | grep -v _test | grep -v unitt | grep -v testdata | grep -v devtools |sed "s/proto$$/pb.go/")

all: $(DEPS)

%.pb.go: %.proto
	@protoc $(FLAGS) $<

