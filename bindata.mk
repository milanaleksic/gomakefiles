# Depends on:
#   GOPATH
#   SOURCEDIR - where is the root of the project

RESOURCES_DIR ?= $(SOURCEDIR)

DATA_DIR ?= $(RESOURCES_DIR)/data

SOURCES_DATA := $(shell find $(DATA_DIR))

BINDATA_DEBUG_FILE ?= $(RESOURCES_DIR)/bindata_debug.go
BINDATA_RELEASE_FILE ?= $(RESOURCES_DIR)/bindata_release.go

BINDATA_PKG ?= main

prepare_bindata: ${GOPATH}/bin/go-bindata

${GOPATH}/bin/go-bindata:
	go get github.com/jteeuwen/go-bindata/go-bindata

${BINDATA_DEBUG_FILE}: ${SOURCES_DATA}
	@echo building debug bindata
	@rm -rf ${BINDATA_RELEASE_FILE}
	@go-bindata --debug -o=${BINDATA_DEBUG_FILE} -pkg ${BINDATA_PKG} ${DATA_DIR}/...
	@goimports -w ${BINDATA_DEBUG_FILE}

${BINDATA_RELEASE_FILE}: ${SOURCES_DATA}
	@echo building release bindata
	@rm -rf ${BINDATA_DEBUG_FILE}
	@go-bindata -nocompress=true -nomemcopy=true -o=${BINDATA_RELEASE_FILE} -pkg ${BINDATA_PKG} ${DATA_DIR}/...
	@goimports -w ${BINDATA_RELEASE_FILE}

.PHONY: clean_bindata
clean_bindata:
	@echo cleaning bindata
	@rm -rf ${BINDATA_DEBUG_FILE}
	@rm -rf ${BINDATA_RELEASE_FILE}

.PHONY: check_undefined_version
check_undefined_version:
	@[ ! `egrep "\-undefined" ${BINDATA_DEBUG_FILE} | wc -l` == "0" ]
